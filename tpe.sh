#!/bin/sh

#Función que limpia el schema del XML
clean_xml() {
  echo "$1" | sed -e 's| xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"||g' \
                   -e 's| generated_at="[^"]*"||g' \
                   -e 's| xmlns="http://schemas.sportradar.com/sportsapi/[a-zA-Z-]*/v3"||g' \
                   -e 's| xsi:schemaLocation="http://schemas.sportradar.com/sportsapi/[a-zA-Z-]*/v3 [^"]*"||g'
}

generate_error_xml() {
  local error_message=$1
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
  <season_data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"./data/season_data.xsd\">
    <error>${error_message}</error>
  </season_data>"
  java net.sf.saxon.Transform -s:season_data.xml -xsl:generate_markdown.xsl -o:season_page.md
}

if [ "$#" -ne 2 ]; then
    generate_error_xml "There must be a name and a year" > season_data.xml
    exit 1
fi  

if [ "$2" -le 2007 ]; then
    generate_error_xml "Year must be greater than 2007" > season_data.xml
    exit 1
fi

API_KEY="uhzyd62653ncbsgztkvsw6e6"

SEASONS_URL="http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY}"

#Hago curl de seasons
seasons_xml=$(curl -s "${SEASONS_URL}")
clean_seasons_xml=$(clean_xml "$seasons_xml")
echo "$clean_seasons_xml" > seasons.xml

#Guardo el ID resultado
season_id=$(java net.sf.saxon.Query extract_season_id.xq season_prefix="$1" season_year="$2")
# echo $season_id

SEASON_INFO_URL="http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${season_id}/info.xml?api_key=${API_KEY}"

#Hago un curl de la información de la season
season_info_xml=$(curl -s "${SEASON_INFO_URL}")
clean_season_info_xml=$(clean_xml "$season_info_xml")
echo "$clean_season_info_xml" > season_info.xml

SEASON_LINEUPS_URL="http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${season_id}/lineups.xml?api_key=${API_KEY}"

#Hago un curl de los lineups de la season
season_lineups_xml=$(curl -s "${SEASON_LINEUPS_URL}")
clean_season_lineups_xml=$(clean_xml "$season_lineups_xml")
echo "$clean_season_lineups_xml" > season_lineups.xml

#Extraigo los datos de la temporada
season_data=$(java net.sf.saxon.Query extract_season_data.xq)
echo $season_data > season_data.xml

java net.sf.saxon.Transform -s:season_data.xml -xsl:generate_markdown.xsl -o:season_page.md