$pjfiles= New-Object -TypeName System.Collections.ArrayList
$pgfiles= New-Object -TypeName System.Collections.ArrayList
$servers= New-Object -TypeName System.Collections.ArrayList
$index = 0
Get-ChildItem .\  -Filter *.csproj | ForEach-Object -Process{
	if($_ -is [System.IO.FileInfo])
	{
	   #Write-Host($_.name);
	   $len=$pjfiles.Add($_.name)
	   #nuget pack  $_.Name
	}
}

##d:\ -Include *.txt -recurse 
Write-Host('#########可选项目文件#########')
foreach($i in $pjfiles){
	$index=$index+1
	Write-Host('['+$index.ToString()+']'+$i)
}

$fileNum = ''

$parttern="^\d+$"

while(!($fileNum -match $parttern)){
	$fileNum = Read-Host -Prompt '请选择文件要打包的项目'
}

Write-Host('正在打包...')

nuget pack  $pjfiles[$fileNum]

#####发布nuget包

Get-ChildItem .\  -Filter *.nupkg | ForEach-Object -Process{
	if($_ -is [System.IO.FileInfo])
	{
	   $len=$pgfiles.Add($_.name)
	}
}


Write-Host('######nuget包↓↓↓↓↓↓#########')
$index=0
foreach($i in $pjfiles){
	$index=$index+1
	Write-Host('['+$index.ToString()+']'+$i)
}
$fileNum=''
while(!($fileNum -match $parttern)){
	$fileNum = Read-Host -Prompt '请选择文件要Push的nuget包'
}

$len = $servers.Add('nuget服务地址1')
$len = $servers.Add('nuget服务地址2')
Write-Host('######nuget服务地址#########')
$index=0
foreach($i in $servers){
	$index=$index+1
	Write-Host('['+$index.ToString()+']'+$i)
}
$serverindex=''
while(!($serverindex -match $parttern)){
	$serverindex = Read-Host -Prompt '请选择服务地址'
}

$nugetKey=Read-Host -Prompt '请请输入nuget服务的key'

Write-Host('正在发布...')

nuget push $pgfiles[$fileNum] $nugetKey -Source $servers[$serverindex]

$key = Read-Host -Prompt '按回车键退出'