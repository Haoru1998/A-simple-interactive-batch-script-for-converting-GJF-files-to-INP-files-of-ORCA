# A-simply-interactive-batch-script-for-converting-GJF-files-to-INP-files-of-ORCA
This interactive script converts GJF files to INP files of ORCA using template files by running Multiwfn

Before running check the location of templated files in your computer, and change it in this script.

# location of template files
<span style="color:red">TEMPLATE_DIR="/home/hao/work/template"</span>

Check the location of Multiwfn software in your computer

<span style="color:red">/opt/Multiwfn/Multiwfn</span> ${inf} << EOF > /dev/null 2>&1
