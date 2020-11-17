import { format } from "@wowts/string";
import {
    existsSync,
    mkdirSync,
    readFileSync,
    readdirSync,
    writeFileSync,
} from "fs";
import { eventDispatcher, ClassId } from "@wowts/wow-mock";
import { registerScripts } from "../scripts/index";
import { getSpellData, SpellData } from "./importspells";
import { ipairs } from "@wowts/lua";
import {
    convertFromSpellData,
    CustomAura,
    CustomAuras,
    CustomSpellData,
} from "./customspell";
import { SpellInfoProperty } from "../Data";
import { IoC } from "../ioc";

let outputDirectory = "src/scripts";
const simcDirectory = process.argv[2];
const profilesDirectory = simcDirectory + "/profiles/Tier25";
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
    "warrior",
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
        spellInfos += ` 	[${spellId}]: { name: "${data.name}", castTime: ${data.cast_time}, minRange: ${data.min_range}, maxRange: ${data.max_range}},\n`;
    }
    spellInfos += "};";
    spellInfos += `export const enum SpellId {
        ${Array.from(spellData.spellDataById.values())
            .filter(
                (x) =>
                    !x.identifier.match(/_unused/) &&
                    !x.identifier.match(/_(\d)$/)
            )
            .map((x) => ` 	${x.identifier} = ${x.id},`)
            .join("\n")}
}
`;
    writeFileSync("../wow-mock/src/spells.ts", spellInfos, {
        encoding: "utf8",
    });
}

const limitLine1 = "// THE REST OF THIS FILE IS AUTOMATICALLY GENERATED";
const limitLine2 = "// ANY CHANGES MADE BELOW THIS POINT WILL BE LOST";

function truncateFile(fileName: string) {
    const file = readFileSync(fileName, { encoding: "utf8" });
    const lines = file.split("\n");
    let output: string[] = [];
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

const modifiedFiles = new Map<string, boolean>();

let files: string[] = [];
const profileFile = process.argv[3];
if (profileFile) {
    files.push(process.argv[3]);
} else {
    let dir = readdirSync(profilesDirectory);
    for (const name of dir) {
        files.push(name);
    }
    files.sort();
}

const spellsByClass = new Map<string, number[]>();
const talentsByClass = new Map<string, number[]>();
const itemsByClass = new Map<string, number[]>();
const spellListsByClass = new Map<string, string[]>();
const azeriteTraitByClass = new Map<string, number[]>();
const essenceByClass = new Map<string, number[]>();
const runeforgeByClass = new Map<string, number[]>();
const conduitByClass = new Map<string, number[]>();
const soulbindAbilityByClass = new Map<string, number[]>();
const customByClass = new Map<string, number[]>();

function getOrSet<T>(map: Map<string, T[]>, className: string) {
    let result = map.get(className);
    if (result) return result;
    result = [];
    map.set(className, result);
    return result;
}

function addId<T>(ids: T[], id?: T) {
    if (id && !ids.includes(id)) {
        ids.push(id);
    }
}

const customIdentifiers = new Map<string, number>();

// Pets and demons
customIdentifiers.set("wild_imp_inner_demons", 143622);
customIdentifiers.set("vilefiend", 135816);
customIdentifiers.set("demonic_tyrant", 135002);
customIdentifiers.set("wild_imp", 55659);
customIdentifiers.set("dreadstalker", 98035);
customIdentifiers.set("darkglare", 103673);
customIdentifiers.set("infernal", 89);
customIdentifiers.set("felguard", 17252);

// Spells missing in the database
customIdentifiers.set("hex", 51514);

// Invisible auras
customIdentifiers.set("garrote_exsanguinated", -703);
customIdentifiers.set("rupture_exsanguinated", -1943);

// Custom spell lists
spellData.spellLists.set("exsanguinated", [
    { identifier: "garrote_exsanguinated", id: -703 },
    { identifier: "rupture_exsanguinated", id: -1943 },
]);

// Fix identifiers
function fixIdentifier(identifier: string, spellId: number) {
    const spell = spellData.spellDataById.get(spellId);
    if (spell) {
        spell.identifier = identifier;
        spellData.identifiers[identifier] = spellId;
    }
}
fixIdentifier("shining_light_free_buff", 327510);
fixIdentifier("sun_kings_blessing_ready_buff", 333315);
fixIdentifier("clearcasting_channel_buff", 277726);

const customIdentifierById = new Map<
    number,
    { id: number; identifier: string }
>();

for (const [key, value] of customIdentifiers.entries()) {
    spellData.identifiers[key] = value;
    customIdentifierById.set(value, { identifier: key, id: value });
}

for (const filename of files) {
    if (!filename.startsWith("generate")) {
        let output: string[] = [];
        let inputName = profilesDirectory + "/" + filename;
        let simc = readFileSync(inputName, { encoding: "utf8" });
        if (simc.indexOf("optimal_raid=") < 0) {
            let source: string | undefined,
                className: string | undefined,
                specialization: string | undefined;
            const matches = simc.match(/[^\r\n]+/g);
            if (matches) {
                for (const line of matches) {
                    if (!source) {
                        if (line.substring(0, 3) == "### ") {
                            source = line.substring(4);
                        }
                    }
                    if (!className) {
                        for (const simcClass of SIMC_CLASS) {
                            let length = simcClass.length;
                            if (
                                line.substring(0, length + 1) ==
                                simcClass + "="
                            ) {
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
            }

            if (!className || !specialization) {
                console.log("className and specialization must be defined");
                continue;
            }

            console.log(filename);
            const ioc = new IoC();
            ioc.ovale.playerGUID = "player";
            ioc.ovale.playerClass = <ClassId>className;
            for (const [key] of spellData.spellLists) {
                ioc.data.buffSpellList[key] = {};
            }
            eventDispatcher.DispatchEvent("ADDON_LOADED", "Ovale");
            eventDispatcher.DispatchEvent("PLAYER_ENTERING_WORLD", "Ovale");
            registerScripts(ioc.scripts);

            let profile = ioc.simulationCraft.ParseProfile(
                simc,
                Object.assign({}, spellData.identifiers)
            );
            if (!profile) continue;
            let profileName = profile.annotation.name.substring(
                1,
                profile.annotation.name.length - 1
            );
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
            output.push(
                format('	const desc = "[9.0] Simulationcraft: %s"', desc)
            );
            output.push("	const code = `");
            output.push(ioc.simulationCraft.Emit(profile, true));
            output.push("`");
            output.push(
                format(
                    '	OvaleScripts.RegisterScript("%s", "%s", name, desc, code, "%s")',
                    profile.annotation.classId,
                    profile.annotation.specialization,
                    "script"
                )
            );
            output.push("}");
            output.push("");

            const outputFileName = "ovale_" + className.toLowerCase() + ".ts";
            console.log("Appending to " + outputFileName + ": " + name);
            let outputName = outputDirectory + "/" + outputFileName;
            if (!modifiedFiles.get(outputName)) {
                modifiedFiles.set(outputName, true);
                truncateFile(outputName);
            }
            writeFileSync(outputName, output.join("\n"), { flag: "a" });

            let classSpells = getOrSet(spellsByClass, className);
            let classTalents = getOrSet(talentsByClass, className);
            let classItems = getOrSet(itemsByClass, className);
            let azeriteTraits = getOrSet(azeriteTraitByClass, className);
            let essences = getOrSet(essenceByClass, className);
            let spellLists = getOrSet(spellListsByClass, className);
            let runeforges = getOrSet(runeforgeByClass, className);
            let conduits = getOrSet(conduitByClass, className);
            let soulbindAbilities = getOrSet(soulbindAbilityByClass, className);
            const custom = getOrSet(customByClass, className);

            const identifiers = ipairs(profile.annotation.symbolList)
                .map((x) => x[1])
                .sort();
            for (const symbol of identifiers) {
                const spellList = spellData.spellLists.get(symbol);
                if (spellList) {
                    for (const spell of spellList) {
                        if (classSpells.indexOf(spell.id) < 0)
                            classSpells.push(spell.id);
                    }
                    if (spellLists.indexOf(symbol) < 0) spellLists.push(symbol);
                    continue;
                }
                const id = spellData.identifiers[symbol];
                if (customIdentifiers.has(symbol)) addId(custom, id);
                else if (symbol.match(/_talent/)) {
                    addId(classTalents, id);
                } else if (symbol.match(/_item$/)) {
                    addId(classItems, id);
                } else if (symbol.match(/_trait$/)) {
                    addId(azeriteTraits, id);
                } else if (symbol.match(/_essence_id$/)) {
                    addId(essences, id);
                } else if (symbol.match(/_runeforge$/)) {
                    addId(runeforges, id);
                } else if (symbol.match(/_conduit$/)) {
                    addId(conduits, id);
                } else if (symbol.match(/_soulbind$/)) {
                    addId(soulbindAbilities, id);
                } else {
                    if (id && classSpells.indexOf(id) < 0) {
                        classSpells.push(id);
                    }
                }
            }
        }
    }
}

function getTooltip(spell: CustomSpellData | SpellData) {
    return spell.tooltip && spell.tooltip.replace(/[\$\\{}%]/g, "");
}

function getDesc(spell: CustomSpellData | SpellData) {
    return spell.desc && spell.desc.replace(/[\$\\{}%]/g, "");
}

function getBuffDefinition(
    identifier: string,
    target: keyof CustomAuras,
    customAura: CustomAura
) {
    const spell = spellData.spellDataById.get(customAura.id);
    if (!spell) return `# Unknown spell id ${customAura.id}`;
    let ret = "";
    if (spell.tooltip) {
        ret = `  # ${getTooltip(spell)}\n`;
    }
    if (target === "player") {
        return `${ret}  SpellAddBuff(${identifier} ${spell.identifier} add=${customAura.stacks})`;
    }
    return `${ret}  SpellAddTargetDebuff(${identifier} ${spell.identifier} add=${customAura.stacks})`;
}

// function getConditions(conditions: Condition[], talentIds: number[]) {
//     let output = "";
//     for (const key of conditions) {
//         if (key.type === "talent") {
//             const talentId = key.id;
//             if (talentId) {
//                 const talent = spellData.talentsById.get(talentId);
//                 if (talent) {
//                     output += ` hastalent(${talent.identifier})`;
//                     if (talentIds.indexOf(talentId) < 0)
//                         talentIds.push(talentId);
//                 }
//             }
//         }
//     }
//     return output;
// }

function getDefinition(
    identifier: string,
    customSpellData: CustomSpellData,
    talentIds: number[],
    spellIds: number[]
) {
    let output = customSpellData.desc ? `# ${getDesc(customSpellData)}\n` : "";
    if (customSpellData.nextRank) {
        const nextRank = spellData.spellDataById.get(customSpellData.nextRank);
        if (nextRank && nextRank.desc) {
            output += `# ${nextRank.rank_str}: ${getDesc(nextRank)}\n`;
        }
    }

    output += `  SpellInfo(${identifier}`;
    for (const key in customSpellData.spellInfo) {
        if (key === "require") continue;
        output += ` ${key}=${
            customSpellData.spellInfo[key as SpellInfoProperty]
        }`;
    }

    // if (customSpellData.conditions)
    //     output += getConditions(customSpellData.conditions, talentIds);

    output += `)\n`;

    for (const require of customSpellData.require) {
        let parameter;
        if (require.talentId) {
            parameter = spellData.talentsById.get(require.talentId)?.identifier;
            talentIds.push(require.talentId);
        }
        output += `  SpellRequire(${customSpellData.identifier} ${
            require.property
        } set=${require.value} enabled=(${require.not ? "not " : ""}${
            require.condition
        }(${parameter ?? ""})))\n`;
    }

    if (
        customSpellData.replace &&
        spellIds.indexOf(customSpellData.replace) >= 0
    ) {
        const replaced = spellData.spellDataById.get(customSpellData.replace);
        if (replaced) {
            output += `  SpellInfo(${replaced.identifier} replaced_by=${identifier}`;
            // if (customSpellData.conditions)
            //     output += getConditions(customSpellData.conditions, talentIds);
            output += ")\n";
        }
    }

    const auras = customSpellData.auras;
    if (auras) {
        for (const key in auras) {
            const k = key as keyof CustomAuras;
            const aura = auras[k];
            if (aura) {
                output += aura
                    .filter((x) => spellIds.indexOf(x.id) >= 0)
                    .map((x) => getBuffDefinition(identifier, k, x))
                    .join("\n");
                output += "\n";
            }
        }
    }
    return output;
}

for (const file of modifiedFiles.keys()) {
    writeFileSync(file, "\n}", { encoding: "utf8", flag: "a" });
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
        if (!spellId) continue;
        const spell = spellData.spellDataById.get(spellId);
        if (!spell) continue;
        const customSpell = convertFromSpellData(
            spell,
            spellData.spellDataById
        );
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

    const sortedSpells = spells.sort((x, y) =>
        x.identifier < y.identifier ? -1 : 1
    );
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

    const spellLists = spellListsByClass.get(className);
    if (spellLists) {
        for (const spellList of spellLists) {
            const spells = spellData.spellLists.get(spellList);
            if (spells) {
                output += `SpellList(${spellList} ${spells
                    .map((x) => x.identifier)
                    .join(" ")})\n`;
            }
        }
    }

    const talents = talentIds
        .map((x) => spellData.talentsById.get(x))
        .filter((x) => x !== undefined)
        .sort((x, y) => (x!.name > y!.name ? 1 : -1));
    for (let i = 0; i < talents.length; i++) {
        const talent = talents[i];
        if (!talent) continue;
        output += `Define(${talent.identifier} ${talent.talentId}) #${talent.id}\n`;
        const spell = spellData.spellDataById.get(talent.spell_id);
        if (spell && spell.desc) {
            output += `# ${getDesc(spell)}\n`;
        }
    }

    function writeIds<T, U extends { identifier: string }>(
        idInSimc: Map<string, T[]>,
        repository: Map<T, U>,
        idProperty: keyof U
    ) {
        const ids = idInSimc.get(className);
        if (ids) {
            for (const id of ids) {
                const item = repository.get(id);
                if (!item) continue;
                output += `Define(${item.identifier} ${item[idProperty]})\n`;
            }
        }
    }

    writeIds(customByClass, customIdentifierById, "id");
    writeIds(itemsByClass, spellData.itemsById, "id");
    writeIds(azeriteTraitByClass, spellData.azeriteTraitById, "spellId");
    writeIds(essenceByClass, spellData.essenceById, "id");
    writeIds(runeforgeByClass, spellData.runeforgeById, "bonus_id");
    writeIds(conduitByClass, spellData.conduitById, "id");
    writeIds(soulbindAbilityByClass, spellData.soulbindAbilityById, "spell_id");

    output += `    \`;
// END`;

    const fileName = outputDirectory + "/ovale_" + className + "_spells.ts";
    let existing = readFileSync(fileName, { encoding: "utf8" });
    const lines = output.split("\n");
    for (const line of lines) {
        if (line.indexOf("//") >= 0 || line.indexOf("`") >= 0) continue;
        existing = existing.split(line.trim()).join("");
    }
    output = existing.replace(
        /\/\/ THIS PART OF THIS FILE IS AUTOMATICALLY GENERATED[^]*\/\/ END/,
        output
    );
    writeFileSync(fileName, output, { encoding: "utf8" });

    // writeCustomSpell(sortedSpells, className, spellData.spellDataById);
}
