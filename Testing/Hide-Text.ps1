function Hide-Text {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[AllowEmptyString()]
		[string]$Text,
		[Parameter(Position=1)]
		[int]$NumberOfCharacters = 5,
		[switch]$FromFront
	)
	$length = $Text.Length
	$textArray = $Text.ToCharArray()
	$newString = ""
	
	if(!($Text)){
		return $newString
	}

	if($length -lt $NumberOfCharacters){
		$NumberOfCharacters = $length
	}
	for ($i = 0; $i -lt $textArray.Count; $i++) {
		#$Text[$i]
		if($FromFront)
		{
			if($i -lt $NumberOfCharacters){
				$newString = $newString + "X"
			}
			else {
				$newString = $newString + $textArray[$i]
			}
		}
		else {
			
			if($length-$i -le $NumberOfCharacters){
				$newString = $newString + "X"
			}
			else {
				$newString = $newString + $textArray[$i]
			}
		}
	}
	$newString
}
