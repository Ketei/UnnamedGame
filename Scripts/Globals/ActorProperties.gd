extends Node

#const world_grid = 24

## Percent damage to health from sex is RELATIVE to the actors max health.

## Uses values from 0 to 99. DO NOT use other values than these
const MinSexHealthDamagePercent: int = 1

## Uses values from 1 to 100. DO NOT use other values than these
const MaxSexHealthDamagePercent: int = 100

# Related to Actors
enum ActorType {NPC, PLAYER}
enum ActorClass {WARRIOR, ARCHER, MAGE}
# Warrior: Sword & Shield. Can block | Standard dodge | Can't counter
# Archer Bow & Dagger. Can't block | Longer Dodge | Can't counter
# Mage: Staff & Scroll. Can block some damage | Shorter dodge | Can counter

enum SexRole {TOP, BOTTOM}
enum Gender {MALE, FEMALE}
enum Pronoun {MALE, FEMALE, NEUTRAL}
enum Experience {REGULAR, ORAL, ANAL, VAGINAL}
enum Species {WOLF, DRAGON, KAIJU}

# Related to materials
#enum Viscocity {FLUID, REGULAR, THICK}
#enum Temperature {FREEZING, COLD, COOL, WARM, HOT, BURNING}
#enum Size {TINY, SMALL, NORMAL, LARGE, HUGE}
#enum Potency {NONE, IMPOTENT, WEAK, NORMAL, STRONG, POTENT}

# Related to Lewd
#enum BirthType {LIVE, EGG, GEM}

# Related to Collisions
#enum ObjectType {CONDITION, LADDER}

# Related to objects
#enum Facing {NULL, UP, RIGHT, DOWN, LEFT}

# StateMachineProperties
#enum StateTerrain {GROUND, AIR, WATER}

