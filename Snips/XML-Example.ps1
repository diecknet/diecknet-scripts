[xml]$xmlDaten = @"
<?xml version="1.0"?>
<!-- A fragment of a book store inventory database -->
<bookstore xmlns:bk="urn:samples">
  <book genre="novel" publicationdate="1997" bk:ISBN="1-861001-57-8">
    <title>Pride And Prejudice</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>24.95</price>
  </book>
  <book genre="novel" publicationdate="1992" bk:ISBN="1-861002-30-1">
    <title>The Handmaid's Tale</title>
    <author>
      <first-name>Margaret</first-name>
      <last-name>Atwood</last-name>
    </author>
    <price>29.95</price>
  </book>
  <book genre="novel" publicationdate="1991" bk:ISBN="1-861001-57-6">
    <title>Emma</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>19.95</price>
  </book>
  <book genre="novel" publicationdate="1982" bk:ISBN="1-861001-45-3">
    <title>Sense and Sensibility</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>19.95</price>
  </book>
</bookstore>
"@

$xmlDaten.bookstore.SelectNodes("title")

$xmlDaten.SelectNodes("//title")

$xmlDaten.SelectNodes("bookstore")

$xmlDaten.SelectNodes("book")

$xmlDaten.SelectNodes("//book")

$xmlDaten.SelectNodes("//book[@publicationdate=1991]")

$xmlDaten.SelectNodes("//book/@genre")

$xmlDaten.bookstore.book | Where-Object {$_.publicationdate -eq 1991 } 

$xmlDaten.bookstore.book | Where-Object {$_.genre } | Select-Object -Property genre


$xmlString = @"
<?xml version="1.0"?>
<!-- A fragment of a book store inventory database -->
<bookstore xmlns:bk="urn:samples">
  <book genre="novel" publicationdate="1997" bk:ISBN="1-861001-57-8">
    <title>Pride And Prejudice</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>24.95</price>
  </book>
  <book genre="novel" publicationdate="1992" bk:ISBN="1-861002-30-1">
    <title>The Handmaid's Tale</title>
    <author>
      <first-name>Margaret</first-name>
      <last-name>Atwood</last-name>
    </author>
    <price>29.95</price>
  </book>
  <book genre="novel" publicationdate="1991" bk:ISBN="1-861001-57-6">
    <title>Emma</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>19.95</price>
  </book>
  <book genre="novel" publicationdate="1982" bk:ISBN="1-861001-45-3">
    <title>Sense and Sensibility</title>
    <author>
      <first-name>Jane</first-name>
      <last-name>Austen</last-name>
    </author>
    <price>19.95</price>
  </book>
</bookstore>
"@

$book=Select-Xml -Content $xmlString -XPath "//book" 
$book[0].Node

$book[0].Node.ISBN

Select-Xml -Path .\Snips\test.xml -XPath "//book"

$xmlString | Select-Xml -XPath "//book"
$xmlDaten | Select-Xml -XPath "//book"

Get-Service wuauserv,windefend | ConvertTo-XML

Get-Service wuauserv,windefend | Select-Object -Property Name,DisplayName,Status,StartType | ConvertTo-XML -As String | Out-File Snips/test2xml.xml -Encoding utf8

$myInfo = [PSCustomObject]@{
  Name    = "Andreas Dieckmann"
  Website = "https://diecknet.de"
  YouTube = "https://youtube.com/@diecknet"
}

$myInfo | ConvertTo-XML -as String -NoTypeInformation

###
$xmlFile = "XML-Example.data.xml"
$xmlDaten = [xml](Get-Content -Path $xmlFile -Encoding utf8)

# zum ändern eines <tag>WERT</tag> Wertes
# übergeordneten Node auswählen
$node = $xmlDaten.SelectSingleNode("//channel")
$node.generator = "PowerShell 5.1"

# Vorschau
$xmlDaten.InnerXML

# zum Ändern einer Eigenschaft eines Tags <tag eigenschaft="beispiel" />
# den Node auswählen
$node = $xmlDaten.rss.channel.item | Where-Object {$_.img.alt -eq "Beispiel Bild" }
$node.img.src = "https://diecknet.de/images/2019-10-21 a new blog (powershell).png"
$node.img.alt = "Ein neuer Blog!"

$xmlDaten.InnerXML

# Speichern der XML Daten
# wahlweise per Methode aus der XML Klasse
$xmlDaten.Save($xmlFile)

# oder nativ per PowerShell
$xmlDaten.InnerXML | Out-File MeineAngepassteXMLDatei.xml -Encoding utf8