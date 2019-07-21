import { format } from "@wowts/string";
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "fs";
import { Ovale } from "../Ovale";
import { eventDispatcher, ClassId } from "@wowts/wow-mock";
import { OvaleEquipment } from "../Equipment";
import { OvaleSpellBook } from "../SpellBook";
import { OvaleStance } from "../Stance";
import { OvaleSimulationCraft, Annotation } from "../SimulationCraft";
import  { registerScripts } from "../scripts/index";
import { getSpellData, SpellData } from "./importspells";
import { ipairs } from "@wowts/lua";
import { convertFromSpellData, CustomAura, CustomAuras, CustomSpellData } from "./customspell";
import { SpellInfo } from "../Data";
import { ConditionNamedParameters } from "../AST";

let outputDirectory = "src/scripts";
const simcDirectory = process.argv[2];
const profilesDirectory = simcDirectory + '/profiles/Tier23';
const SIMC_CLASS = [
    "deathknight",
    "demonhunter",
    "druid",
    "hunter",
    "mage",
    "monk",
    "paladin",
    "priest",
    "rogue",
    "shaman",
    "warlock",
    "warrior"
];

function Canonicalize(s: string) {
    let token = "xXxUnDeRsCoReXxX";
    s = s.toLowerCase();
    s = s.replace(/[\s\-\_\(\)\{\}\[\]]/g, token);
    s = s.replace(/\./g, "");
    s = s.replace(/xXxUnDeRsCoReXxX/g, "_");
    s = s.replace("_+", "_");
    s = s.replace("^_", "");
    s = s.replace("_$", "");
    return s;
}

if (!existsSync(outputDirectory)) mkdirSync(outputDirectory);

const spellData = getSpellData(simcDirectory);



// function escapeString(s: string) {
//     if (!s) return s;
//     return s.replace(/"/, '\\"');
// }

if (existsSync("../wow-mock")) {
    let spellInfos = `export const spellInfos:{[k: number]: { name: string, castTime: number, minRange: number, maxRange: number }} = {\n`;
    for (const [spellId, data] of spellData.spellDataById) {
        spellInfos += ` 	[${spellId}]: { name: "${data.name}", castTime: ${data.cast_min}, minRange: ${data.min_range}, maxRange: ${data.max_range}},\n`;
    }
    spellInfos += "};";
    writeFileSync("../wow-mock/spells.ts", spellInfos, { encoding: "utf8" });
}

const limitLine1 = "// THE REST OF THIS FILE IS AUTOMATICALLY GENERATED";
const limitLine2 = "// ANY CHANGES MADE BELOW THIS POINT WILL BE LOST";

function truncateFile(fileName: string) {
    const file = readFileSync(fileName, { encoding: "utf8" });
    const lines = file.split("\n");
    let output: string[] = []
    for (const line of lines) {
        if (line.indexOf(limitLine1) >= 0) {
            break;
        }
        output.push(line);
    }
    output.push(limitLine1);
    output.push(limitLine2);
    output.push("");
    writeFileSync(fileName, output.join("\n"));
}

for (const simcClass of SIMC_CLASS) {
    truncateFile(outputDirectory + "/ovale_" + simcClass + ".ts");
}

let files: string[] = []
{
    let dir = readdirSync(profilesDirectory);
    for (const name of dir) {
        files.push(name);
    }
    files.sort();
}


const spellsByClass = new Map<string, number[]>();
const talentsByClass = new Map<string, number[]>();
const itemsByClass = new Map<string, number[]>();
const azeriteTraitByClass = new Map<string, number[]>();

for (const filename of files) {
    // if (filename.indexOf('Hunter') < 0) continue;
    if (!filename.startsWith("generate")) {
        let output: string[] = []
        let inputName = profilesDirectory + "/" + filename;
        let simc = readFileSync(inputName, { encoding: "utf8" });
        if (simc.indexOf("optimal_raid=") < 0) {
            let source: string, className: string, specialization: string;
            for (const line of simc.match(/[^\r\n]+/g)) {
                if (!source) {
                    if (line.substring(0, 3) == "### ") {
                        source = line.substring(4);
                    }
                }
                if (!className) {
                    for (const simcClass of SIMC_CLASS) {
                        let length = simcClass.length;
                        if (line.substring(0, length + 1) == simcClass + "=") {
                            className = simcClass.toUpperCase();
                        }
                    }
                }
                if (!specialization) {
                    if (line.substring(0, 5) == "spec=") {
                        specialization = line.substring(5);
                    }
                }
                if (className && specialization) {
                    break;
                }
            }
            
            console.log(filename);
            Ovale.playerGUID = "player";
            Ovale.playerClass = <ClassId>className;
            eventDispatcher.DispatchEvent("ADDON_LOADED", "Ovale");
            OvaleEquipment.UpdateEquippedItems();
            OvaleSpellBook.Update();
            OvaleStance.UpdateStances();
            registerScripts();

            const annotation: Annotation = {
                dictionary: Object.assign({}, spellData.identifiers)
            };
            let profile = OvaleSimulationCraft.ParseProfile(simc, annotation);
            let profileName = profile.annotation.name.substring(1, profile.annotation.name.length - 1);
            let name: string, desc: string;
            if (source) {
                desc = format("%s: %s", source, profileName);
            } else {
                desc = profileName;
            }
            name = Canonicalize(desc);
            output.push("");
            output.push("{");
            output.push(format('	const name = "sc_%s"', name));
            output.push(format('	const desc = "[8.2] Simulationcraft: %s"', desc));
            output.push("	const code = `");
            output.push(OvaleSimulationCraft.Emit(profile, true));
            output.push("`");
            output.push(format('	OvaleScripts.RegisterScript("%s", "%s", name, desc, code, "%s")', profile.annotation.class, profile.annotation.specialization, "script"));
            output.push("}");
            output.push("");
            let outputFileName = "ovale_" + className.toLowerCase() + ".ts";
            console.log("Appending to " + outputFileName + ": " + name);
            let outputName = outputDirectory + "/" + outputFileName;
            writeFileSync(outputName, output.join("\n"), { flag: 'a' });

            let classSpells = spellsByClass.get(className);
            if (!classSpells) {
                classSpells = [];
                spellsByClass.set(className, classSpells);
            }
            let classTalents = talentsByClass.get(className);
            if (!classTalents) {
                classTalents = [];
                talentsByClass.set(className, classTalents);
            }
            let classItems = itemsByClass.get(className);
            if (!classItems) {
                classItems = [];
                itemsByClass.set(className, classItems);
            }
            let azeriteTraits = azeriteTraitByClass.get(className);
            if (!azeriteTraits){
                azeriteTraits = [];
                azeriteTraitByClass.set(className, azeriteTraits);
            }
            const identifiers = ipairs(profile.annotation.symbolList).map(x => x[1]).sort();
            for (const symbol of identifiers) {
                const id = spellData.identifiers[symbol];
                if (symbol.match(/_talent/)) {
                    if (id && classTalents.indexOf(id) < 0) {
                        classTalents.push(id);
                    }
                } else if (symbol.match(/_item$/)) {
                    if (id && classItems.indexOf(id) < 0) {
                        classItems.push(id);
                    }
                } else if (symbol.match(/_trait$/)) {
                    if (id && azeriteTraits.indexOf(id) < 0) {
                        azeriteTraits.push(id);
                    }
                } else {
                    if (id && classSpells.indexOf(id) < 0) {
                        classSpells.push(id)
                    }
                }
            }
        }
    }
}

function getTooltip(spell: CustomSpellData | SpellData) {
    return spell.tooltip.replace(/[\$\\{}%]/g, '');
}

function getDesc(spell: CustomSpellData | SpellData) {
    return spell.desc.replace(/[\$\\{}%]/g, '');
}

function getBuffDefinition(identifier: string, target: keyof CustomAuras, customAura: CustomAura) {
    const spell = spellData.spellDataById.get(customAura.id);
    if (!spell) return `# Unknown spell id ${customAura.id}`;
    let ret = "";
    if (spell.tooltip) {
        ret = `  # ${getTooltip(spell)}\n`;
    }
    if (target === "player") {
        return `${ret}  SpellAddBuff(${identifier} ${spell.identifier}=${customAura.stacks})`;
    }
    return `${ret}  SpellAddTargetDebuff(${identifier} ${spell.identifier}=${customAura.stacks})`;
}

function getConditions(conditions: ConditionNamedParameters, talentIds: number[]) {
    let output = "";
    for (const key in conditions) {
        if (key === "talent") {
            const talentId = conditions[key];
            const talent = spellData.talentsById.get(talentId);
            output += ` ${key}=${talent.identifier}`;
            if (talentIds.indexOf(talentId) < 0) talentIds.push(talentId);
        }
    }
    return output;
}

function getDefinition(identifier: string, customSpellData: CustomSpellData, talentIds: number[], spellIds: number[]) {
    let output = (customSpellData.desc) ? `# ${getDesc(customSpellData)}\n` : "";
    if (customSpellData.nextRank) {
        const nextRank = spellData.spellDataById.get(customSpellData.nextRank);
        if (nextRank && nextRank.desc) {
            output += `# ${nextRank.rank_str}: ${getDesc(nextRank)}\n`;
        }
    }

    output += `  SpellInfo(${identifier}`;
    for (const key in customSpellData.spellInfo) {
        output += ` ${key}=${customSpellData.spellInfo[key as keyof SpellInfo]}`;
    }

    if (customSpellData.conditions) output += getConditions(customSpellData.conditions, talentIds);
    
    output += `)\n`;

    if (customSpellData.replace && spellIds.indexOf(customSpellData.replace) >= 0) {
        const replaced = spellData.spellDataById.get(customSpellData.replace);
        output += `  SpellInfo(${replaced.identifier} replaced_by=${identifier}`;
        if (customSpellData.conditions) output += getConditions(customSpellData.conditions, talentIds);
        output += ")\n";
    }

    const auras = customSpellData.auras;
    if (auras) {
        for (const key in auras) {
            const k = key as keyof CustomAuras;
            if (auras[k]) {
                output += auras[k].filter(x => spellIds.indexOf(x.id) >=0).map(x => getBuffDefinition(identifier, k, x)).join("\n");
                output += "\n";
            }
        }
    }
    return output;
}

for (const [className, spellIds] of spellsByClass) {
    let output = `// THIS PART OF THIS FILE IS AUTOMATICALLY GENERATED
${limitLine2}
    let code = \``;        
    const talentIds = talentsByClass.get(className) || [];
    const spells: CustomSpellData[] = [];
    const remainingsSpellIds = spellIds.concat();
    while (remainingsSpellIds.length) {
        const spellId = remainingsSpellIds.pop();
        const spell = spellData.spellDataById.get(spellId);
        const customSpell = convertFromSpellData(spell, spellData.spellDataById);
        spells.push(customSpell);
        // if (customSpell.auras) {
        //     for (const t in customSpell.auras) {
        //         const target = t as keyof CustomAuras;
        //         for (const aura of customSpell.auras[target]) {
        //             if (spells.every(x => x.id !== aura.id) && spellIds.indexOf(aura.id) < 0) {
        //                 spellIds.push(aura.id);
        //             }
        //         }
        //     }
        // }
    }

    const sortedSpells = spells.sort((x, y) => x.identifier < y.identifier ? -1 : 1);
    for (const spell of sortedSpells) {
        if (!spell) continue;
        output += `Define(${spell.identifier} ${spell.id})\n`;
        output += getDefinition(spell.identifier, spell, talentIds, spellIds);
//         if (!buffAdded && !debuffAdded && !spell.tooltip && spell.duration) {
//             output += `Define(${spell.identifier}_dummy -${spell.id})
//     SpellInfo(${spell.identifier}_dummy duration=${spell.duration})
//     SpellAddBuff(${spell.identifier} ${spell.identifier}_dummy=1)
// `
//         }
    }

    const talents = talentIds.map(x => spellData.talentsById.get(x)).filter(x => x !== undefined).sort((x,y) => x.name > y.name ? 1 : -1);
    for (let i = 0; i < talents.length; i++) {
        const talent = talents[i];
        output += `Define(${talent.identifier} ${talent.talentId}) #${talent.id}\n`;
        const spell = spellData.spellDataById.get(talent.spell_id);
        if (spell && spell.desc) {
            output += `# ${getDesc(spell)}\n`;
        }
    }
    
    const itemIds = itemsByClass.get(className);
    if (itemIds) {
        for (const itemId of itemIds) {
            const item = spellData.itemsById.get(itemId);
            output += `Define(${item.identifier} ${itemId})\n`;
        }
    }

    const traitsIds = azeriteTraitByClass.get(className);
    if (traitsIds) {
        for (const traitId of traitsIds) {
            const trait = spellData.azeriteTraitById.get(traitId);
            output += `Define(${trait.identifier} ${trait.spellId})\n`;
        }
    }

    output+=`    \`;
// END`;

    const fileName = outputDirectory + "/ovale_" + className + "_spells.ts";
    let existing = readFileSync(fileName, { encoding: 'utf8'});
    const lines = output.split('\n');
    for (const line of lines) {
        if (line.indexOf("//") >= 0 || line.indexOf('`') >= 0) continue;
        existing = existing.split(line.trim()).join("");
    }
    output = existing.replace(/\/\/ THIS PART OF THIS FILE IS AUTOMATICALLY GENERATED[^]*\/\/ END/, output);
    writeFileSync(fileName, output, { encoding: 'utf8' });

    // writeCustomSpell(sortedSpells, className, spellData.spellDataById);  
}