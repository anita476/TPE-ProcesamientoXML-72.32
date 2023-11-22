
declare option saxon:output "indent=yes";

(: parte 1: crear el subarbol season :)
declare function local:getSeason() as node(){
 let $d := doc("season_info.xml")//season_info/season
 return <season>
 			<name>{data($d/@name)}</name>
 			<competition>
 				<name>{data($d/competition/@name)}</name>
 				<gender>{data($d/competition/@gender)}</gender>
 			</competition>
 			<date>
 				<start>{data($d/@start_date)}</start>
 				<end>{data($d/@end_date)}</end>
 				<year>{data($d/@year)}</year>
 			</date>
 		</season>
};

(: parte 2: crear el subarbol stages :)

(: obtengo las stages desde $d que es root :)
declare function local:getStages($d as node()) {
	<stages>
	{for $e in $d/stages/stage
	return <stage phase="{data($e/@phase)}" start_date="{data($e/@start_date)}" end_date="{data($e/@end_date)}" >{
	local:getGroups($e)}
	</stage>}</stages>
};

(: obtengo los groups para 1 stage $d:)
declare function local:getGroups($d as node()){
	<groups>{
		for $e in $d/groups/group
		return <group>{local:getCompetitors($e)}</group>
	}</groups>
};

(:  obtengo los competidores para $d group :)
declare function local:getCompetitors($d as node()){
	for $e in $d/competitors/competitor
	return <competitor id="{data($e/@id)}"><name>{data($e/@name)}</name><abbreviation>{data($e/@abbreviation)}</abbreviation></competitor>
};



(: esta función me permitirá tener una colección de los ids de 1 competitor en particular:)
declare function local:getDistinctsID($c){
let $e := data($c/players/player/@id)
return distinct-values($e)
};

(: esta funcion me permite tener una coleccion de los ids de los equipos, recibe los competitors en los lineups:)

declare function local:getDistinctCompetitorID($c){
	let $e := data($c/competitor/@id)
	return distinct-values($e)
};

(:ahora que ya tengo los valores distintivos de id, puedo completar la info de cada player:)
declare function local:getPlayers($c){
	for $e in local:getDistinctsID($c)
	return <player id="{$e}">
				<name>{distinct-values($c/players/player[@id=$e]/@name)}</name>
				<type>{distinct-values($c/players/player[@id=$e]/@type)}</type>
				<date_of_birth>{distinct-values($c/players/player[@id=$e]/@date_of_birth)}</date_of_birth>
				<nationality>{distinct-values($c/players/player[@id=$e]/@nationality)}</nationality>
				<events_played>{count($c/players/player[@id=$e and @played="true"])}</events_played>
			</player>
};

declare function local:getCompetitor($d){
	for $e in local:getDistinctCompetitorID($d)
	return <competitor id="{$e}">
			<name>{distinct-values($d/competitor[@id=$e]/@name)}</name>
			<players>{local:getPlayers($d/competitor[@id=$e])}</players>
			</competitor>
};

declare function local:getFile(){
<season_data>
{local:getSeason()}
{let $d := doc("season_info.xml")//season_info
 return local:getStages($d)
 }
<competitors> {
	let $d := doc("season_lineups.xml")//season_lineups/lineup/lineups/competitors
	return local:getCompetitor($d)}
	 </competitors>
</season_data>

};



local:getFile() 

