import { next, LuaObj } from "@wowts/lua";
import { huge } from "@wowts/math";
import { BaseState } from "./BaseState";
import { PositionalParameters, NamedParameters, AstNodeSnapshot } from "./AST";
import { AuraType } from "./Data";
import { isString } from "./tools";
let INFINITY = huge;

export type ConditionResult = [
    /** If defined, the value is defined only after this time in seconds */
    start?: number,
    /** If defined, the value is defined only before this time in seconds */
    end?: number,
    /** The value */
    value?: number | string,
    /** If defined, the time at which the value is defined, otherwise, the value is a constant */
    origin?: number,
    /** If defined, the rate at which each second the value change, otherwise, the value is a constant */
    rate?: number
];
export type ConditionFunction = (
    positionalParams: PositionalParameters,
    namedParams: NamedParameters,
    atTime: number
) => ConditionResult;

export type ConditionAction = (
    positionalParams: PositionalParameters,
    namedParams: NamedParameters,
    atTime: number,
    result: AstNodeSnapshot
) => void;

export type ComparatorId = "atleast" | "atmost" | "equal" | "less" | "more";

const COMPARATOR: { [k in ComparatorId]: boolean } = {
    atleast: true,
    atmost: true,
    equal: true,
    less: true,
    more: true,
};

export function isComparator(token: string): token is ComparatorId {
    return COMPARATOR[token as ComparatorId] !== undefined;
}

export class OvaleConditionClass {
    private conditions: LuaObj<ConditionFunction> = {};
    private actions: LuaObj<ConditionAction> = {};
    private spellBookConditions: LuaObj<boolean> = {
        spell: true,
    };

    /**
     * Register a new condition
     * @param name The condition name (must be lowercase)
     * @param isSpellBookCondition Is the first argument a spell id from the spell book or a spell list name
     * @param func The function to register
     */
    RegisterCondition(
        name: string,
        isSpellBookCondition: boolean,
        func: ConditionFunction
    ) {
        this.conditions[name] = func;
        if (isSpellBookCondition) {
            this.spellBookConditions[name] = true;
        }
    }

    registerAction(name: string, func: ConditionAction) {
        this.actions[name] = func;
    }

    UnregisterCondition(name: string) {
        delete this.conditions[name];
    }
    IsCondition(name: string) {
        return this.conditions[name] != undefined;
    }
    IsSpellBookCondition(name: string) {
        return this.spellBookConditions[name] != undefined;
    }
    EvaluateCondition(
        name: string,
        positionalParams: PositionalParameters,
        namedParams: NamedParameters,
        atTime: number
    ) {
        return this.conditions[name](positionalParams, namedParams, atTime);
    }
    HasAny() {
        return next(this.conditions) !== undefined;
    }
}

export function ParseCondition(
    namedParams: NamedParameters,
    baseState: BaseState,
    defaultTarget?: string
): [target: string, filter: AuraType | undefined, mine: boolean] {
    let target =
        (isString(namedParams.target) && namedParams.target) ||
        defaultTarget ||
        "player";
    namedParams.target = namedParams.target || target;

    if (target === "cycle" || target === "target") {
        target = baseState.next.defaultTarget;
    }
    let filter: AuraType | undefined;
    if (namedParams.filter) {
        if (namedParams.filter == "debuff") {
            filter = "HARMFUL";
        } else if (namedParams.filter == "buff") {
            filter = "HELPFUL";
        }
    }
    let mine = true;
    if (namedParams.any && namedParams.any == 1) {
        mine = false;
    }
    return [target, filter, mine];
}

export function TestBoolean(a: boolean, yesno: "yes" | "no"): ConditionResult {
    if (!yesno || yesno == "yes") {
        if (a) {
            return [0, INFINITY];
        }
    } else {
        if (!a) {
            return [0, INFINITY];
        }
    }
    return [];
}

export function ReturnValue(
    value: number,
    origin: number,
    rate: number
): ConditionResult {
    return [0, INFINITY, value, origin, rate];
}

export function ReturnValueBetween(
    start: number,
    ending: number,
    value: number,
    origin: number,
    rate: number
): ConditionResult {
    if (start >= ending) return [];
    return [start, ending, value, origin, rate];
}

export function ReturnConstant(
    value: number | string | undefined
): ConditionResult {
    return [0, INFINITY, value, 0, 0];
}

export function ReturnBoolean(value: boolean): ConditionResult {
    if (value) return [0, INFINITY];
    return [];
}

export function TestValue(
    start: number,
    ending: number,
    value: number | undefined,
    origin: number | undefined,
    rate: number | undefined,
    comparator: string | undefined,
    limit: number | undefined
): ConditionResult {
    if (value === undefined || origin === undefined || rate === undefined) {
        return [];
    }
    start = start || 0;
    ending = ending || INFINITY;
    if (!comparator) {
        if (start < ending) {
            return [start, ending, value, origin, rate];
        } else {
            return [0, INFINITY, 0, 0, 0];
        }
    } else if (!isComparator(comparator)) {
        return [];
    } else if (!limit) {
        return [];
    } else if (rate == 0) {
        if (
            (comparator == "less" && value < limit) ||
            (comparator == "atmost" && value <= limit) ||
            (comparator == "equal" && value == limit) ||
            (comparator == "atleast" && value >= limit) ||
            (comparator == "more" && value > limit)
        ) {
            return [start, ending];
        }
    } else if (
        (comparator == "less" && rate > 0) ||
        (comparator == "atmost" && rate > 0) ||
        (comparator == "atleast" && rate < 0) ||
        (comparator == "more" && rate < 0)
    ) {
        let t = (limit - value) / rate + origin;
        ending = (ending < t && ending) || t;
        return [start, ending];
    } else if (
        (comparator == "less" && rate < 0) ||
        (comparator == "atmost" && rate < 0) ||
        (comparator == "atleast" && rate > 0) ||
        (comparator == "more" && rate > 0)
    ) {
        let t = (limit - value) / rate + origin;
        start = (start > t && start) || t;
        return [start, INFINITY];
    }
    return [];
}

export function Compare(
    value: number,
    comparator: string | undefined,
    limit: number | undefined
): ConditionResult {
    return TestValue(0, INFINITY, value, 0, 0, comparator, limit);
}
