/*1. Encode information about the monsters and their moves*/

/*basicType(T): to represent the idea that T is a basic type.*/
basicType(psychic).
basicType(fighting).
basicType(normal).
basicType(dark).

/*monster(MO,T): to represent the idea that MO is a monster of type T.*/
monster(annihilape,ghost).
monster(espathra,psychic).
monster(flamigo,fighting).
monster(lechonk,normal).
monster(mabosstiff,dark).

/*move(MV,T): to represent the idea that MV is a move of type T.*/
move(lowKick,fighting).
move(shadowPunch,ghost).
move(rageFist,ghost).
move(bodySlam,normal).
move(psybeam,psychic).
move(quickAttack,normal).
move(lowKick,fighting).
move(shadowBall,ghost).
move(lowKick,fighting).
move(payback,dark).
move(megaKick,normal).
move(closeCombat,fighting).
move(tackle,normal).
move(takeDown,normal).
move(zenHeadButt,psychic).
move(bodySlam,normal).
move(snarl,dark).
move(lick,ghost).
move(bite,dark).
move(bodySlam,normal).

/*monsterMove(MO,MV): to represent the idea that monster MO has a move MV.*/
monsterMove(annihilape,lowKick).
monsterMove(annihilape,shadowPunch).
monsterMove(annihilape,rageFist).
monsterMove(annihilape,bodySlam).
monsterMove(espathra,psybeam).
monsterMove(espathra,quickAttack).
monsterMove(espathra,lowKick).
monsterMove(espathra,shadowBall).
monsterMove(flamigo,lowKick).
monsterMove(flamigo,payback).
monsterMove(flamigo,megaKick).
monsterMove(flamigo,closeCombat).
monsterMove(lechonk,tackle).
monsterMove(lechonk,takeDown).
monsterMove(lechonk,zenHeadButt).
monsterMove(lechonk,bodySlam).
monsterMove(mabosstiff,snarl).
monsterMove(mabosstiff,lick).
monsterMove(mabosstiff,bite).
monsterMove(mabosstiff,bodySlam).

/*2. Encode effectiveness information*/

/*typeEffectiveness(E,T1,T2): a move of type T1 used again monsters of type T2 has effectiveness E*/
typeEffectiveness(weak,psychic,psychic).
typeEffectiveness(strong,psychic,fighting).
typeEffectiveness(superweak,psychic,dark).
typeEffectiveness(ordinary,psychic,ghost).
typeEffectiveness(ordinary,psychic,normal).
typeEffectiveness(weak,fighting,psychic).
typeEffectiveness(ordinary,fighting,fighting).
typeEffectiveness(strong,fighting,dark).
typeEffectiveness(superweak,fighting,ghost).
typeEffectiveness(strong,fighting,normal).
typeEffectiveness(strong,dark,psychic).
typeEffectiveness(weak,dark,fighting).
typeEffectiveness(weak,dark,dark).
typeEffectiveness(strong,dark,ghost).
typeEffectiveness(ordinary,dark,normal).
typeEffectiveness(strong,ghost,psychic).
typeEffectiveness(ordinary,ghost,fighting).
typeEffectiveness(weak,ghost,dark).
typeEffectiveness(strong,ghost,ghost).
typeEffectiveness(superweak,ghost,normal).
typeEffectiveness(ordinary,normal,psychic).
typeEffectiveness(ordinary,normal,fighting).
typeEffectiveness(ordinary,normal,dark).
typeEffectiveness(superweak,normal,ghost).
typeEffectiveness(ordinary,normal,normal).

/*3. Encode basic effectiveness relationships*/

/*moreEffective(E1,E2): E1 is more effective than E2*/
moreEffective(strong,ordinary).
moreEffective(ordinary,weak).
moreEffective(weak,superweak).
moreEffective(strong,weak).
moreEffective(ordinary,superweak).

/*4. Encode transitive effectiveness information*/

/*moreEffectiveThan(E1,E2): E1 is more effective than E2*/
moreEffectiveThan(E1, E2) :- moreEffective(E1, E2).
moreEffectiveThan(E1, E2) :- moreEffective(E1, E), moreEffectiveThan(E, E2).

/*5. Define a Prolog rule called monsterMoveMatch*/

/*monsterMoveMatch(T,MO1,MO2,MV) which represents the idea that monster MO1 and monster MO2 both have a move MV which has type T*/
monsterMoveMatch(T,MO1,MO2,MV) :- monsterMove(MO1, MV),  % monster MO1 has move MV
                                  monsterMove(MO2, MV),  % monster MO2 has same move MV
                                  move(MV, T).           % move MV is of Type T

/*6. Define a Prolog rule called moreEffectiveMoveType*/

/*moreEffectiveMoveType(MV1,MV2,T) to represent the idea that move MV1 is more effective than move MV2 against monsters of type T*/
moreEffectiveMoveType(MV1, MV2, T) :- move(MV1, T),                  % move MV1 is of type T
                                      move(MV2, T),                  % move MV2 is of same type T
                                      typeEffectiveness(E1, T, _),   % E1 is the effectiveness for type T
                                      typeEffectiveness(E2, T, _),   % E2 is the effectiveness for type T
                                      moreEffectiveThan(E1, E2).     % E1 is more effective than E2 for type T

/*7. Define a Prolog rule called moreEffectiveMove*/

/*moreEffectiveMove(MO1,MV1,MO2,MV2) to represent the idea that if monster MO1 performs move MV1 against MO2, and monster MO2 performs move MV2 against MO1*/
moreEffectiveMove(MO1,MV1,MO2,MV2) :- monster(MO1, T1),                         % monster MO1 is of type T1
                                      monster(MO2, T2),                         % monster MO2 is of type T2
                                      monsterMove(MO1, MV1),                    % monster MO1 has MV1
                                      monsterMove(MO2, MV2),                    % monster MO2 has MV2
                                      moreEffectiveMoveType(MV1, MV2, T2),      % MV1 is more effective than MV2 for T2
                                      not(moreEffectiveMoveType(MV2, MV1, T1)). % MV2 is not more effective than MV1 for T1

