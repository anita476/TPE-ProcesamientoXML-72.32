declare variable $season_prefix as xs:string external;
declare variable $season_year as xs:string external;
declare option saxon:output "omit-xml-declaration=yes";
let $ids := doc("seasons.xml")/seasons/season[starts-with(@name,$season_prefix) and contains(@start_date,$season_year)]/@id
return if (count($ids) gt 0) then data($ids[1]) else ()