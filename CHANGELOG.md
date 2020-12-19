# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [9.0.28](https://github.com/Sidoine/Ovale/compare/9.0.27...9.0.28) (2020-12-19)


### Bug Fixes

* it does not take INFINITY seconds when we already have more power than required ([#753](https://github.com/Sidoine/Ovale/issues/753)) ([1afa181](https://github.com/Sidoine/Ovale/commit/1afa1814af3c002158f8e4b9eccbbe0966aba2a7))
* specialization spells ([0695abd](https://github.com/Sidoine/Ovale/commit/0695abdc3b057e9973f207f716b84a8917f073c4))
* spellFlashCore wasn't working with bartender and more fixes ([5dc77ac](https://github.com/Sidoine/Ovale/commit/5dc77acb3a8a01f78f1402177b58548fd67f62d5))

### [9.0.27](https://github.com/Sidoine/Ovale/compare/9.0.26...9.0.27) (2020-12-19)


### Bug Fixes

* check for time to Runes when computing Time to Power. ([#752](https://github.com/Sidoine/Ovale/issues/752)) ([3ddb48a](https://github.com/Sidoine/Ovale/commit/3ddb48aeac9be142fe603f911f3b7ef84b82b463))
* register correct callback to AceTimer:ScheduleTimer() ([#742](https://github.com/Sidoine/Ovale/issues/742)) ([d8df7bd](https://github.com/Sidoine/Ovale/commit/d8df7bd244902f838153ba13587df80afd1af506))
* spells are usable only if they meet all of their power requirements ([#746](https://github.com/Sidoine/Ovale/issues/746)) ([18d7714](https://github.com/Sidoine/Ovale/commit/18d77148dfd32c04b7b2c9f559b0aca624edb8c2)), closes [#737](https://github.com/Sidoine/Ovale/issues/737)
* update to T26 SimulationCraft scripts ([bc3a3e1](https://github.com/Sidoine/Ovale/commit/bc3a3e1e564cfecaff1ddd248c3e6297ab42dfc9))

### [9.0.26](https://github.com/Sidoine/Ovale/compare/9.0.25...9.0.26) (2020-12-16)


### Bug Fixes

* remove unnecessary use of "tostring" in isCovenant. ([#734](https://github.com/Sidoine/Ovale/issues/734)) ([b07880b](https://github.com/Sidoine/Ovale/commit/b07880bce0ac478117d42fc57ffb3c53b0c5613d))
* show cooldown frame if a cooldown is active ([#743](https://github.com/Sidoine/Ovale/issues/743)) ([bead88d](https://github.com/Sidoine/Ovale/commit/bead88d403df49c26bb17d84daff9f56e0a52c35)), closes [#739](https://github.com/Sidoine/Ovale/issues/739)
* update tstolua ([56fcf58](https://github.com/Sidoine/Ovale/commit/56fcf581f68357d8b0808edde610788791c23855)), closes [#745](https://github.com/Sidoine/Ovale/issues/745)

### [9.0.25](https://github.com/Sidoine/Ovale/compare/9.0.24...9.0.25) (2020-12-15)


### Bug Fixes

* copy Bindings.xml to output ([926420b](https://github.com/Sidoine/Ovale/commit/926420baf98d8dcdf3c63d0dfe5e2a63ed692201)), closes [#738](https://github.com/Sidoine/Ovale/issues/738)
* replace SpellFlash by LibButtonGlow-1.0 ([31b45e6](https://github.com/Sidoine/Ovale/commit/31b45e6e0447355ca3b836ded662b585736c3345)), closes [#700](https://github.com/Sidoine/Ovale/issues/700)
* was always showing development version ([5a45f05](https://github.com/Sidoine/Ovale/commit/5a45f05a87ebed174fd524f6ca4ffe02e919fc35)), closes [#733](https://github.com/Sidoine/Ovale/issues/733)

### [9.0.24](https://github.com/Sidoine/Ovale/compare/9.0.23...9.0.24) (2020-12-14)


### Bug Fixes

* **priest:** fix various bugs with shadow priest script ([523377a](https://github.com/Sidoine/Ovale/commit/523377aabcabe87668488142c1881fd15abacbb2)), closes [#732](https://github.com/Sidoine/Ovale/issues/732)

### [9.0.23](https://github.com/Sidoine/Ovale/compare/9.0.22...9.0.23) (2020-12-13)


### Bug Fixes

* **runner:** the correct spell was not chosen in group ([431a644](https://github.com/Sidoine/Ovale/commit/431a644478a82d4830ad0ce88c23bf7be8c4901f)), closes [#723](https://github.com/Sidoine/Ovale/issues/723)
* add max_xxx back ([b7f79a0](https://github.com/Sidoine/Ovale/commit/b7f79a067184b56976a2e4f0f1a175b39962b0f1))
* **priest:** work on shadow priest script ([e4cd224](https://github.com/Sidoine/Ovale/commit/e4cd224c89d02218e5954cb0f1a64919196a6fed))
* add value parameter to conditions ([02896fc](https://github.com/Sidoine/Ovale/commit/02896fcd3011aa17bb90f8e631b53d9759180ccb))
* some buffs were named _unused ([b619780](https://github.com/Sidoine/Ovale/commit/b619780d4d959c0fa9294068c66f7777be0bbe52))
* undue syntax errors on action parameters ([7b6a118](https://github.com/Sidoine/Ovale/commit/7b6a118b94616244edc27e6aec8acb61f7ca1fd2))

### [9.0.22](https://github.com/Sidoine/Ovale/compare/v9.0.21...v9.0.22) (2020-12-09)


### Bug Fixes

* spell auras that were hidden were overwriting those that were not ([41a78e4](https://github.com/Sidoine/Ovale/commit/41a78e43ed0f76e0760ca3081c7b209f50ab85c8)), closes [#684](https://github.com/Sidoine/Ovale/issues/684)
* **hunter:** add conditions on kill_shot and harpoon ([f7140b6](https://github.com/Sidoine/Ovale/commit/f7140b670bdee0e663096ae735518e58a246aea7)), closes [#699](https://github.com/Sidoine/Ovale/issues/699)
* convenant debug pannel was not displayed ([3b5fc92](https://github.com/Sidoine/Ovale/commit/3b5fc92e1a6beb0eb6aedb41a28d9d39a2532f2d)), closes [#726](https://github.com/Sidoine/Ovale/issues/726)
* remove bitrotted and likely incorrect code regarding "nocd". ([#729](https://github.com/Sidoine/Ovale/issues/729)) ([f704bd0](https://github.com/Sidoine/Ovale/commit/f704bd0e42177b418dc56d1f3589b613c3f6a6d7))

## 9.0.21 (2020-12-07)

### Bug Fixes

-   relax condition on target parameter ([87f61a3](https://github.com/Sidoine/Ovale/commit/87f61a38dffb98866cdde4c3280f90d4e6ec3a04)), closes [#715](https://github.com/Sidoine/Ovale/issues/715)
