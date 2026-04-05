#!/bin/bash

# 1. Define the Help Function
show_help() {
    echo "Usage: ./get_addons.sh [OPTIONS]"
    echo ""
    echo "Searches the Addon table for specific FrameworkSupportList versions and Vendor names."
    echo "Outputs a clean list of Addon Names to a text file."
    echo ""
    echo "Options:"
    echo "  -h,  --help             Show this help message and exit."
    echo "  -i,  --include          Versions to INCLUDE (comma-separated, e.g., 5,6)."
    echo "  -e,  --exclude          Versions to EXCLUDE (comma-separated, e.g., 4)."
    echo "  -iv, --include-vendor   Vendors to INCLUDE (comma-separated, e.g., silverstripe)."
    echo "  -ev, --exclude-vendor   Vendors to EXCLUDE (comma-separated, e.g., symbiote)."
    echo ""
    echo "Examples:"
    echo "  ./get_addons.sh --include 5,6 --exclude 4 --include-vendor silverstripe"
    echo "  ./get_addons.sh -i 5 -ev symbiote,dnadesign"
}

# 2. Parse Command-Line Arguments
INCLUDE_VALS=""
EXCLUDE_VALS=""
INCLUDE_VENDOR=""
EXCLUDE_VENDOR=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0 ;;
        -i|--include) INCLUDE_VALS="$2"; shift ;;
        -e|--exclude) EXCLUDE_VALS="$2"; shift ;;
        -iv|--include-vendor) INCLUDE_VENDOR="$2"; shift ;;
        -ev|--exclude-vendor) EXCLUDE_VENDOR="$2"; shift ;;
        *) echo "Unknown parameter passed: $1. Use -h for help."; exit 1 ;;
    esac
    shift
done

# Check if at least one parameter was provided
if [ -z "$INCLUDE_VALS" ] && [ -z "$EXCLUDE_VALS" ] && [ -z "$INCLUDE_VENDOR" ] && [ -z "$EXCLUDE_VENDOR" ]; then
    echo "Error: You must provide at least one filtering flag."
    echo "Run './get_addons.sh --help' for usage."
    exit 1
fi

# 3. Extract Database Credentials
DB_USER=""
DB_PASS=""
DB_NAME=""

if [ -f ".env" ]; then
    echo "Found .env file. Extracting credentials..."
    DB_USER=$(grep -E '^SS_DATABASE_USERNAME=' .env | cut -d= -f2 | tr -d '"' | tr -d "'")
    DB_PASS=$(grep -E '^SS_DATABASE_PASSWORD=' .env | cut -d= -f2 | tr -d '"' | tr -d "'")
    DB_NAME=$(grep -E '^SS_DATABASE_NAME=' .env | cut -d= -f2 | tr -d '"' | tr -d "'")
elif [ -f "_ss_environment.php" ]; then
    echo "Found _ss_environment.php file. Extracting credentials..."
    DB_USER=$(grep 'SS_DATABASE_USERNAME' _ss_environment.php | awk -F"'" '{print $4}')
    DB_PASS=$(grep 'SS_DATABASE_PASSWORD' _ss_environment.php | awk -F"'" '{print $4}')
    DB_NAME=$(grep 'SS_DATABASE_NAME' _ss_environment.php | awk -F"'" '{print $4}')
else
    echo "Error: Neither .env nor _ss_environment.php were found in this directory."
    exit 1
fi

if [ -z "$DB_NAME" ]; then
    echo "Error: Could not parse database credentials."
    exit 1
fi

# 4. Build the SQL 'WHERE' Clause Dynamically
WHERE_SQL=""

# Helper function to append to WHERE_SQL
append_sql() {
    if [ -n "$WHERE_SQL" ]; then
        WHERE_SQL="$WHERE_SQL AND ($1)"
    else
        WHERE_SQL="($1)"
    fi
}

# Process Included Framework Versions (OR logic)
if [ -n "$INCLUDE_VALS" ]; then
    INC_SQL=""
    IFS=',' read -ra INC_ARR <<< "$INCLUDE_VALS"
    for val in "${INC_ARR[@]}"; do
        if [ -n "$INC_SQL" ]; then INC_SQL="$INC_SQL OR "; fi
        INC_SQL="$INC_SQL FrameworkSupportList LIKE '%${val}%'"
    done
    append_sql "$INC_SQL"
fi

# Process Excluded Framework Versions (AND logic)
if [ -n "$EXCLUDE_VALS" ]; then
    EXC_SQL=""
    IFS=',' read -ra EXC_ARR <<< "$EXCLUDE_VALS"
    for val in "${EXC_ARR[@]}"; do
        if [ -n "$EXC_SQL" ]; then EXC_SQL="$EXC_SQL AND "; fi
        EXC_SQL="$EXC_SQL FrameworkSupportList NOT LIKE '%${val}%'"
    done
    append_sql "$EXC_SQL"
fi

# Process Included Vendors (OR logic)
if [ -n "$INCLUDE_VENDOR" ]; then
    V_INC_SQL=""
    IFS=',' read -ra V_INC_ARR <<< "$INCLUDE_VENDOR"
    for val in "${V_INC_ARR[@]}"; do
        if [ -n "$V_INC_SQL" ]; then V_INC_SQL="$V_INC_SQL OR "; fi
        V_INC_SQL="$V_INC_SQL Name LIKE '${val}/%'"
    done
    append_sql "$V_INC_SQL"
fi

# Process Excluded Vendors (AND logic)
if [ -n "$EXCLUDE_VENDOR" ]; then
    V_EXC_SQL=""
    IFS=',' read -ra V_EXC_ARR <<< "$EXCLUDE_VENDOR"
    for val in "${V_EXC_ARR[@]}"; do
        if [ -n "$V_EXC_SQL" ]; then V_EXC_SQL="$V_EXC_SQL AND "; fi
        V_EXC_SQL="$V_EXC_SQL Name NOT LIKE '${val}/%'"
    done
    append_sql "$V_EXC_SQL"
fi

# 5. Finalize Query and Execute
# Notice it now ONLY selects 'Name'
QUERY="SELECT Name, Repository FROM Addon WHERE ${WHERE_SQL};"
OUTPUT_FILE="addon_report.txt"

echo "Executing Query..."

# 6. Write Title and Parameters to the Output File First
echo "=== ADDON QUERY REPORT ===" > "$OUTPUT_FILE"
if [ -n "$INCLUDE_VALS" ]; then echo "Included Versions: $INCLUDE_VALS" >> "$OUTPUT_FILE"; fi
if [ -n "$EXCLUDE_VALS" ]; then echo "Excluded Versions: $EXCLUDE_VALS" >> "$OUTPUT_FILE"; fi
if [ -n "$INCLUDE_VENDOR" ]; then echo "Included Vendors : $INCLUDE_VENDOR" >> "$OUTPUT_FILE"; fi
if [ -n "$EXCLUDE_VENDOR" ]; then echo "Excluded Vendors : $EXCLUDE_VENDOR" >> "$OUTPUT_FILE"; fi
echo "==========================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Append (>>) the raw query results (ONLY the names) to the file
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "$QUERY" >> "$OUTPUT_FILE"

