use Cwd;
my $dir=getcwd;

my $compressStatus = `sh ./readInstitution.sh @ARGV[0] $dir`;
# print "Compress Status:$compressStatus\n";
if($compressStatus gt 2){
    exit;
}
# my $inst=`cat /usr/local/adacnew/Patients/Institution_0/Institution`;
my $inst=`cat $dir/Institution`;
$inst =~ m/(\s\sPatientLite\s=\{\n(.*\n){6})+/;
my $instHead=$`;
my $PatientLiteList=$&;
my $instTail=$';
my @patientLiteArray = ();
while($PatientLiteList =~ m/\s\sPatientLite\s=\{\n(.*\n){6}/g)
{
    push @patientLiteArray,$&;
}
if(@patientLiteArray>1){
    my $compressPara = (( $CompressStatus eq 1 ))?" -z":"";
    my $untarCMD = "gtar$compressPara -x -f @ARGV[0]";
    print "$untarCMD\n";
    `$untarCMD`;
    for ( my $i = 1; $i <= @patientLiteArray; ++$i ) 
    {
        my $patientLite = @patientLiteArray[i-1];
        my $patientLite_tmp = $patientLite;
        $patientLite_tmp =~ /FormattedDescription.*/;
        my $description = $&;
        # print "$patientLite_tmp\n";
        my @description = split(/\s=\s/,$description);
        my $volueDescription = @description[1];
        $patientLite_tmp =~ /PatientPath.*/;
        my $p_path = $&;
        my @patientPath = split(/\s=\s/,$p_path);
        my $patientPath = @patientPath[1];
        $volueDescription =~ s/&&/-/g;
        $volueDescription =~ s/[\";]//g;
        $volueDescription =~ s/[\s]/_/g;
        my $filePath = ((@ARGV[2]=~/\/$/))?@ARGV[2]:"@ARGV[2]/";
        $fileName = $filePath.$volueDescription.".tar";
        $instTail =~ s/BackupVolume.*/BackupVolume = \"$volueDescription\"\;/g;
        $instTail =~ s/BackupFileName.*/BackupFileName = \"$fileName\"\;/g;
        my $newInst = $instHead.$patientLite.$instTail;
        my $packageCMD = "gnutar -c -h -f $fileName --exclude=.auto.plan.Trial.binary.* -C $dir Institution -C $dir $patientPath 2>&1";
        print "$packageCMD\n";
        # print "$newInst\n";
        # `$packageCMD`
    }
}