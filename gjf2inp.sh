#!/bin/bash
# Author: Haoru
# Description: Batch convert .gjf files to ORCA .inp files using templates

# location of template files
TEMPLATE_DIR="/home/hao/work/template"

echo "========================================="
echo "  Batch Convert GJF to ORCA INP Files"
echo "========================================="
echo ""
echo "Available templates:"
echo "1) frequency"
echo "2) optimization"
echo "3) optimization frequency"
echo "4) transition state"
echo "5) point energy"
echo "6) IRC"
echo "7) freeze optimization frequency"
echo "8) optimization with XTB for openCOSMO-RS"
echo "9) optimization for openCOSMO-RS"
echo "10) optimization frequency for openCOSMO-RS"
echo "11) point energy for openCOSMO-RS"
echo ""
read -p "Select template [1-11]: " choice

case $choice in
    1) 
        template_src="${TEMPLATE_DIR}/freq.inp"
        task_type="B3LYP D3 def2-SVP freq"
        task_prefix="freq"
        ;;
    2) 
        template_src="${TEMPLATE_DIR}/opt.inp"
        task_type="B97-3c opt"
        task_prefix="opt"
        ;;		
    3) 
        template_src="${TEMPLATE_DIR}/optfreq.inp"
        task_type="B3LYP D3 def2-SVP opt freq"
        task_prefix="optfreq"
        ;;
    4) 
        template_src="${TEMPLATE_DIR}/ts.inp"
        task_type="B3LYP D3 def2-SVP ts"
        task_prefix="ts"
        ;;
    5) 
        template_src="${TEMPLATE_DIR}/pe.inp"
        task_type="wB97M-V def2-TZVP pe"
        task_prefix="pe"
        ;;
    6) 
        template_src="${TEMPLATE_DIR}/irc.inp"
        task_type="B3LYP D3 def2-SVP IRC"
        task_prefix="IRC"
        ;;
    7) 
        template_src="${TEMPLATE_DIR}/freeze.inp"
        task_type="B97-3c opt freq"
        task_prefix="freeze"
        ;;
    8) 
        template_src="${TEMPLATE_DIR}/XTB.inp"
        task_type="GFN2-xTB opt"
        task_prefix="XTB"		
    9) 
        template_src="${TEMPLATE_DIR}/RS-opt1.inp"
        task_type="BP86 def2-TZVP(-f) optimization CPCM"
        task_prefix="RS-opt"
        ;;
    10) 
        template_src="${TEMPLATE_DIR}/RS-opt2.inp"
        task_type="BP86 def2-TZVP optimization frequency CPCM"
        task_prefix="RS-optfreq"
        ;;		
    11) 
        template_src="${TEMPLATE_DIR}/RS-pe.inp"
        task_type="BP86 def2-TZVPD pe CPCM"
        task_prefix="RS-pe"
        ;;			
    *) 
        echo "Invalid choice! Please select 1-11."
        exit 1
        ;;
esac

# Check the available template files
if [[ ! -f "$template_src" ]]; then
    echo "Error: Template file not found: $template_src"
    echo "Please create template files in: $TEMPLATE_DIR"
    exit 1
fi

echo "Using template: $template_src"
echo "Task type: $task_type"
echo "Output prefix: $task_prefix"
echo ""

# Count the files that need to be converted
nfile=$(ls *.gjf 2>/dev/null | wc -l)

if [ $nfile -eq 0 ]; then
    echo "No .gjf files found in current directory!"
    exit 1
fi

echo "Found $nfile file(s) to convert"
echo ""

# Continue converting?
read -p "Continue? [Y/n]: " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Starting conversion..."
echo "========================================="

# Start converting
icc=0
for inf in *.gjf
do
    ((icc++))
    
    # Extract name of files
    basename="${inf%.gjf}"
    # output:name.inp
    outf="${task_prefix}-${basename}.inp"
    
    echo "[$icc/$nfile] Converting ${inf} -> ${outf}"
    
    /opt/Multiwfn/Multiwfn ${inf} << EOF > /dev/null 2>&1
100
2
12
${outf}
-100
${template_src}
0
q
EOF
    
    # Check output
    if [[ -f "$outf" ]]; then
        echo "        ✓ Success"
    else
        echo "        ✗ Failed"
    fi
done

echo "========================================="
echo "  Conversion completed!"
echo "  Total: $nfile files converted"
echo "========================================="