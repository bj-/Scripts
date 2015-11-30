clear 
$xmldata= [xml] (Get-Content -path .\text.xml)

Get-Content -path .\text.xml

$xmldata.SelectNodes("//Contact[@type!=`"personal`"]") | % { 
	$xmldata.SelectNodes("//Contacts").item(0).removechild($_)
}
$xmldata.save((pwd).path+"\nuevo.xml")

Get-Content -path .\nuevo.xml