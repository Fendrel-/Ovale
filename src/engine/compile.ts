import { OvaleAzeriteArmor } from "../states/AzeriteArmor";
import {
    AstAnnotation,
    OvaleASTClass,
    AstCheckBoxNode,
    AstIconNode,
    AstListItemNode,
    AstItemInfoNode,
    AstItemRequireNode,
    AstListNode,
    AstScoreSpellsNode,
    AstSpellAuraListNode,
    AstSpellInfoNode,
    AstSpellRequireNode,
    SpellAuraKeyWord,
    AstScriptNode,
} from "./ast";
import { OvaleConditionClass } from "./condition";
import { OvaleCooldownClass } from "../states/Cooldown";
import { AuraType, OvaleDataClass, SpellAddAuras, SpellInfo } from "./data";
import { OvalePaperDollClass } from "../states/PaperDoll";
import { POWER_TYPES, PowerType } from "../states/Power";
import { OvaleSpellBookClass } from "../states/SpellBook";
import { Controls } from "./controls";
import aceEvent, { AceEvent } from "@wowts/ace_event-3.0";
import {
    ipairs,
    pairs,
    tonumber,
    tostring,
    wipe,
    LuaArray,
    lualength,
    truthy,
    LuaObj,
    kpairs,
} from "@wowts/lua";
import { match, sub } from "@wowts/string";
import { insert } from "@wowts/table";
import { GetSpellInfo } from "@wowts/wow-mock";
import { isNumber } from "../tools/tools";
import { OvaleDebugClass, Tracer } from "./debug";
import { OvaleProfilerClass, Profiler } from "./profiler";
import { OvaleOptionsClass } from "../ui/Options";
import { OvaleClass } from "../Ovale";
import { AceModule } from "@wowts/tsaddon";
import { OvaleScoreClass } from "../ui/Score";

const NUMBER_PATTERN = "^%-?%d+%.?%d*$";

export function RequireValue(
    value: string | number
): [string | number, boolean] {
    const required = sub(tostring(value), 1, 1) != "!";
    if (!required) {
        value = sub(<string>value, 2);
        if (truthy(match(value, NUMBER_PATTERN))) {
            return [tonumber(value), required];
        }
    }
    return [value, required];
}

export function RequireNumber(value: string | number): [number, boolean] {
    if (isNumber(value)) return [value, true];
    const required = sub(tostring(value), 1, 1) != "!";
    if (!required) {
        value = sub(value, 2);
        return [tonumber(value), required];
    }
    return [tonumber(value), required];
}

const auraTableDispatch: Record<
    SpellAuraKeyWord,
    { filter: AuraType; target: keyof SpellAddAuras }
> = {
    spelladdbuff: { filter: "HELPFUL", target: "player" },
    spelladddebuff: { filter: "HARMFUL", target: "player" },
    spelladdpetbuff: { filter: "HELPFUL", target: "pet" },
    spelladdpetdebuff: { filter: "HARMFUL", target: "pet" },
    spelladdtargetbuff: { filter: "HELPFUL", target: "target" },
    spelladdtargetdebuff: { filter: "HARMFUL", target: "target" },
    spelldamagebuff: { filter: "HELPFUL", target: "damage" },
    spelldamagedebuff: { filter: "HARMFUL", target: "damage" },
};

export class OvaleCompileClass {
    private serial: number | undefined = undefined;
    private ast: AstScriptNode | undefined = undefined;

    private self_serial = 0;
    private timesEvaluated = 0;
    private icon: LuaArray<AstIconNode> = {};
    private tracer: Tracer;
    private profiler: Profiler;
    private module: AceModule & AceEvent;

    constructor(
        private ovaleAzerite: OvaleAzeriteArmor,
        private ovaleAst: OvaleASTClass,
        private ovaleCondition: OvaleConditionClass,
        private ovaleCooldown: OvaleCooldownClass,
        private ovalePaperDoll: OvalePaperDollClass,
        private ovaleData: OvaleDataClass,
        ovaleProfiler: OvaleProfilerClass,
        private ovaleDebug: OvaleDebugClass,
        private ovaleOptions: OvaleOptionsClass,
        private ovale: OvaleClass,
        private ovaleScore: OvaleScoreClass,
        private ovaleSpellBook: OvaleSpellBookClass,
        private controls: Controls
    ) {
        this.tracer = ovaleDebug.create("OvaleCompile");
        this.profiler = ovaleProfiler.create("OvaleCompile");
        this.module = ovale.createModule(
            "OvaleCompile",
            this.OnInitialize,
            this.OnDisable,
            aceEvent
        );
    }

    private EvaluateAddCheckBox(node: AstCheckBoxNode) {
        const ok = true;
        const [name, positionalParams, namedParams] = [
            node.name,
            node.rawPositionalParams,
            node.rawNamedParams,
        ];
        const description =
            (node.description.type === "string" && node.description.value) ||
            node.name;
        let defaultValue = false;
        for (const [, v] of ipairs(positionalParams)) {
            if (v.type === "string" && v.value === "default") {
                defaultValue = true;
                break;
            }
        }

        if (
            this.controls.addCheckBox(
                name,
                description,
                defaultValue,
                namedParams.enabled
            )
        ) {
            this.self_serial = this.self_serial + 1;
            this.tracer.Debug(
                "New checkbox '%s': advance age to %d.",
                name,
                this.self_serial
            );
        }
        return ok;
    }

    private EvaluateAddIcon(node: AstIconNode) {
        this.icon[lualength(this.icon) + 1] = node;
        return true;
    }

    private EvaluateAddListItem(node: AstListItemNode) {
        const ok = true;
        const [name, item, positionalParams, namedParams] = [
            node.name,
            node.item,
            node.rawPositionalParams,
            node.rawNamedParams,
        ];
        if (item) {
            let defaultValue = false;
            for (const [, v] of ipairs(positionalParams)) {
                if (v.type === "string" && v.value == "default") {
                    defaultValue = true;
                    break;
                }
            }

            const description =
                (node.description.type === "string" &&
                    node.description.value) ||
                item;

            if (
                this.controls.addListItem(
                    name,
                    item,
                    description,
                    defaultValue,
                    namedParams.enabled
                )
            ) {
                this.self_serial = this.self_serial + 1;
                this.tracer.Debug(
                    "New list '%s': advance age to %d.",
                    name,
                    this.self_serial
                );
            }
        }
        return ok;
    }

    private EvaluateItemInfo(node: AstItemInfoNode) {
        let ok = true;
        const [itemId, namedParams] = [node.itemId, node.rawNamedParams];
        if (itemId) {
            const ii = this.ovaleData.ItemInfo(itemId);
            for (const [k, v] of kpairs(namedParams)) {
                if (k == "proc") {
                    const buff = v;
                    if (buff.type === "value" && isNumber(buff.value)) {
                        const name = "item_proc_" + namedParams.proc;
                        const list = this.ovaleData.buffSpellList[name] || {};
                        list[buff.value] = true;
                        this.ovaleData.buffSpellList[name] = list;
                    } else {
                        ok = false;
                        break;
                    }
                } else {
                    if (v.type === "value" || v.type === "string")
                        (ii as any)[k] = v.value;
                    else {
                        ok = false;
                        break;
                    }
                }
            }
            this.ovaleData.itemInfo[itemId] = ii;
        }
        return ok;
    }

    private EvaluateItemRequire(node: AstItemRequireNode) {
        const property = node.property;
        const ii = this.ovaleData.ItemInfo(node.itemId);
        const tbl = ii.require[property] || {};
        insert(tbl, node);
        ii.require[property] = tbl;
        return true;
    }

    private EvaluateList(node: AstListNode) {
        let ok = true;
        const [name, positionalParams] = [node.name, node.rawPositionalParams];
        let listDB: "itemList" | "buffSpellList";
        if (node.keyword == "ItemList") {
            listDB = "itemList";
        } else {
            listDB = "buffSpellList";
        }
        const list = this.ovaleData[listDB][name] || {};
        for (const [, _id] of pairs(positionalParams)) {
            if (_id.type === "value" && isNumber(_id.value)) {
                list[_id.value] = true;
            } else {
                this.tracer.Error(
                    "%s is not a number in the '%s' list",
                    _id.asString,
                    name
                );
                ok = false;
                break;
            }
        }
        this.ovaleData[listDB][name] = list;
        return ok;
    }

    private EvaluateScoreSpells(node: AstScoreSpellsNode) {
        let ok = true;
        const [positionalParams] = [node.rawPositionalParams];
        for (const [, _spellId] of ipairs(positionalParams)) {
            if (_spellId.type === "value" && isNumber(_spellId.value)) {
                this.ovaleScore.AddSpell(_spellId.value);
            } else {
                ok = false;
                break;
            }
        }
        return ok;
    }

    private EvaluateSpellAuraList(node: AstSpellAuraListNode) {
        const ok = true;

        const [spellId] = [node.spellId];
        if (!spellId) {
            this.tracer.Error("No spellId for name %s", node.name);
            return false;
        }
        const keyword = node.keyword;
        const si = this.ovaleData.SpellInfo(spellId);
        if (si.aura) {
            const auraInfo = auraTableDispatch[keyword];
            const auraTable = si.aura[auraInfo.target];
            const filter = auraInfo.filter;
            const tbl = auraTable[filter] || {};
            tbl[node.buffSpellId] = node;
            const buff = this.ovaleData.SpellInfo(node.buffSpellId);
            buff.effect = auraInfo.filter;
        }
        return ok;
    }

    private EvaluateSpellInfo(node: AstSpellInfoNode) {
        const addpower: LuaObj<PowerType> = {};
        for (const [, powertype] of ipairs(POWER_TYPES)) {
            const key = `add${powertype}`;
            addpower[key] = powertype;
        }
        let ok = true;
        const [spellId, , namedParams] = [
            node.spellId,
            node.rawPositionalParams,
            node.rawNamedParams,
        ];
        if (spellId) {
            const si = this.ovaleData.SpellInfo(spellId);
            for (const [k, v] of kpairs(namedParams)) {
                if (k == "add_duration") {
                    if (v.type === "value") {
                        let realValue = v.value;
                        if (
                            namedParams.pertrait &&
                            namedParams.pertrait.type === "value"
                        ) {
                            realValue =
                                v.value *
                                this.ovaleAzerite.TraitRank(
                                    namedParams.pertrait.value
                                );
                        }
                        const addDuration = si.add_duration || 0;
                        si.add_duration = addDuration + realValue;
                    } else {
                        ok = false;
                        break;
                    }
                } else if (k == "add_cd") {
                    const value = tonumber(v);
                    if (value) {
                        const addCd = si.add_cd || 0;
                        si.add_cd = addCd + value;
                    } else {
                        ok = false;
                        break;
                    }
                } else if (k == "addlist" && v.type === "string") {
                    const list = this.ovaleData.buffSpellList[v.value] || {};
                    list[spellId] = true;
                    this.ovaleData.buffSpellList[v.value] = list;
                } else if (k == "dummy_replace" && v.type === "string") {
                    let [spellName] = GetSpellInfo(v.value);
                    if (!spellName) spellName = v.value;
                    this.ovaleSpellBook.AddSpell(spellId, spellName);
                } else if (k == "learn" && v.type === "value" && v.value == 1) {
                    const [spellName] = GetSpellInfo(spellId);
                    if (spellName)
                        this.ovaleSpellBook.AddSpell(spellId, spellName);
                } else if (k == "shared_cd" && v.type === "string") {
                    si.shared_cd = v.value;
                    this.ovaleCooldown.AddSharedCooldown(v.value, spellId);
                } else if (addpower[k] != undefined) {
                    if (v.type === "value") {
                        let realValue = v.value;
                        if (
                            namedParams.pertrait &&
                            namedParams.pertrait.type === "value"
                        ) {
                            realValue =
                                v.value *
                                this.ovaleAzerite.TraitRank(
                                    namedParams.pertrait.value
                                );
                        }
                        const power = <number>si[k as keyof SpellInfo] || 0;
                        (<any>si)[k] = power + realValue;
                    } else {
                        this.tracer.Error(
                            "Unexpected value type %s in a addpower SpellInfo parameter (should be value)",
                            v.type
                        );
                        ok = false;
                        break;
                    }
                } else {
                    if (v.type === "value" || v.type === "string")
                        (si as any)[k] = v.value;
                    else {
                        this.tracer.Error(
                            "Unexpected value type %s in a SpellInfo parameter (should be value or string)",
                            v.type
                        );
                        ok = false;
                        break;
                    }
                }
            }
        }
        return ok;
    }

    private EvaluateSpellRequire(node: AstSpellRequireNode) {
        const ok = true;
        const [spellId] = [
            node.spellId,
            node.rawPositionalParams,
            node.rawNamedParams,
        ];
        const property = node.property;
        const si = this.ovaleData.SpellInfo(spellId);
        const tbl = si.require[property] || {};
        insert(tbl, node);
        si.require[property] = tbl;
        return ok;
    }

    /** This attempt to replace an unknown spell by a spell with
     * the same name that is known in a Spell function call. In the case of
     * a spell list, it tries to find the one that is known. */
    private AddMissingVariantSpells(annotation: AstAnnotation) {
        if (annotation.spellNode) {
            for (const [, spellIdParam] of ipairs(annotation.spellNode)) {
                if (spellIdParam.type === "value") {
                    const spellId = spellIdParam.value;
                    if (
                        !this.ovaleSpellBook.IsKnownSpell(spellId) &&
                        !this.ovaleCooldown.IsSharedCooldown(spellId)
                    ) {
                        const spellName = this.ovaleSpellBook.GetSpellName(
                            spellId
                        );
                        if (spellName) {
                            const [name] = GetSpellInfo(spellName);
                            if (spellName == name) {
                                this.tracer.Debug(
                                    "Learning spell %s with ID %d.",
                                    spellName,
                                    spellId
                                );
                                this.ovaleSpellBook.AddSpell(
                                    spellId,
                                    spellName
                                );
                            }
                        } else {
                            this.tracer.Error(
                                "Unknown spell with ID %s.",
                                spellId
                            );
                        }
                    }
                } else if (spellIdParam.type === "string") {
                    if (!this.ovaleData.buffSpellList[spellIdParam.value]) {
                        this.tracer.Error(
                            "Unknown spell list %s",
                            spellIdParam.value
                        );
                    }
                } else if (spellIdParam.type === "variable") {
                    this.tracer.Error(
                        "Spell argument %s must be either a spell id or a spell list name.",
                        spellIdParam.name
                    );
                } else {
                    this.tracer.Error(
                        "Spell argument must be either a spell id or a spell list name."
                    );
                }
            }
        }
    }

    // private trinket: LuaArray<number> = {};
    UpdateTrinketInfo() {
        // TODO
        // [
        //     this.trinket[1],
        //     this.trinket[2],
        // ] = this.ovaleEquipment.GetEquippedTrinkets();
        // for (let i = 1; i <= 2; i += 1) {
        //     let itemId = this.trinket[i];
        //     let ii = itemId && this.ovaleData.ItemInfo(itemId);
        //     let buffId = ii && ii.buff;
        //     if (buffId) {
        //         if (isLuaArray(buffId)) {
        //             for (const [, id] of ipairs(buffId)) {
        //                 this.AddToBuffList(id);
        //             }
        //         } else {
        //             this.AddToBuffList(buffId);
        //         }
        //     }
        // }
    }

    private OnInitialize = () => {
        // TODO Remove these
        this.module.RegisterMessage(
            "Ovale_CheckBoxValueChanged",
            this.ScriptControlChanged
        );
        this.module.RegisterMessage(
            "Ovale_ListValueChanged",
            this.ScriptControlChanged
        );
        this.module.RegisterMessage(
            "Ovale_ScriptChanged",
            this.Ovale_ScriptChanged
        );
        this.module.RegisterMessage(
            "Ovale_SpecializationChanged",
            this.Ovale_ScriptChanged
        );

        this.module.SendMessage("Ovale_ScriptChanged");
    };

    private OnDisable = () => {
        this.module.UnregisterMessage("Ovale_CheckBoxValueChanged");
        this.module.UnregisterMessage("Ovale_ListValueChanged");
        this.module.UnregisterMessage("Ovale_ScriptChanged");
        this.module.UnregisterMessage("Ovale_SpecializationChanged");
    };
    private Ovale_ScriptChanged = (event: string) => {
        this.CompileScript(
            this.ovaleOptions.db.profile.source[
                `${
                    this.ovale.playerClass
                }_${this.ovalePaperDoll.GetSpecialization()}`
            ]
        );
        this.EventHandler(event);
    };

    private ScriptControlChanged = (event: string, name: string) => {
        if (!name) {
            this.EventHandler(event);
        } else {
            let control;
            if (event == "Ovale_CheckBoxValueChanged") {
                control = this.controls.checkBoxesByName[name];
            } else if (event == "Ovale_ListValueChanged") {
                control = this.controls.listsByName[name];
            }
            if (control && control.triggerEvaluation) {
                this.EventHandler(event);
            }
        }
    };

    private EventHandler = (event: string) => {
        this.self_serial = this.self_serial + 1;
        this.tracer.Debug("%s: advance age to %d.", event, this.self_serial);
        this.ovale.needRefresh();
    };
    CompileScript(name: string) {
        this.ovaleDebug.ResetTrace();
        this.tracer.Debug("Compiling script '%s'.", name);
        if (this.ast) {
            this.ovaleAst.Release(this.ast);
            this.ast = undefined;
        }
        if (this.ovaleCondition.HasAny()) {
            this.ast = this.ovaleAst.parseNamedScript(name);
            this.tracer.Debug(
                `Compilation result: ${
                    (this.ast !== undefined && "success") || "failed"
                }`
            );
        } else {
            this.tracer.Debug("No conditions. No need to compile.");
        }
        this.controls.reset();
        return this.ast;
    }
    EvaluateScript(ast?: AstScriptNode, forceEvaluation?: boolean) {
        this.profiler.StartProfiling("OvaleCompile_EvaluateScript");
        let changed = false;
        ast = ast || this.ast;
        // this.tracer.Debug(
        //     `ast?: ${(this.ast !== undefined && "yes") || "no"} serial: ${
        //         this.serial || "nil"
        //     }. asked: ${this.self_serial}`
        // );
        if (
            ast &&
            (forceEvaluation || !this.serial || this.serial < this.self_serial)
        ) {
            this.tracer.Debug("Script has changed. Evaluating...");
            changed = true;
            let ok = true;
            wipe(this.icon);
            this.ovaleData.Reset();
            this.ovaleCooldown.ResetSharedCooldowns();
            this.timesEvaluated = this.timesEvaluated + 1;
            this.serial = this.self_serial;
            for (const [, node] of ipairs(ast.child)) {
                if (node.type == "checkbox") {
                    ok = this.EvaluateAddCheckBox(node);
                } else if (node.type == "icon") {
                    ok = this.EvaluateAddIcon(node);
                } else if (node.type == "list_item") {
                    ok = this.EvaluateAddListItem(node);
                } else if (node.type == "item_info") {
                    ok = this.EvaluateItemInfo(node);
                } else if (node.type == "itemrequire") {
                    ok = this.EvaluateItemRequire(node);
                } else if (node.type == "list") {
                    ok = this.EvaluateList(node);
                } else if (node.type == "score_spells") {
                    ok = this.EvaluateScoreSpells(node);
                } else if (node.type == "spell_aura_list") {
                    ok = this.EvaluateSpellAuraList(node);
                } else if (node.type == "spell_info") {
                    ok = this.EvaluateSpellInfo(node);
                } else if (node.type == "spell_require") {
                    ok = this.EvaluateSpellRequire(node);
                } else if (
                    node.type !== "define" &&
                    node.type !== "add_function"
                ) {
                    this.tracer.Error("Unknown node type", node.type);
                    ok = false;
                }
                if (!ok) {
                    break;
                }
            }
            if (ok) {
                if (ast.annotation)
                    this.AddMissingVariantSpells(ast.annotation);
                this.UpdateTrinketInfo();
            }
        }
        this.profiler.StopProfiling("OvaleCompile_EvaluateScript");
        return changed;
    }
    GetFunctionNode(name: string) {
        let node;
        if (
            this.ast &&
            this.ast.annotation &&
            this.ast.annotation.customFunction
        ) {
            node = this.ast.annotation.customFunction[name];
        }
        return node;
    }
    GetIconNodes() {
        return this.icon;
    }
    DebugCompile() {
        this.tracer.Print(
            "Total number of times the script was evaluated: %d",
            this.timesEvaluated
        );
    }
}
