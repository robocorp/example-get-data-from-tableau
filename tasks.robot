*** Settings ***
Library    RPA.Browser.Selenium
Library    RPA.JSON
Library    OperatingSystem
Library    String
Library    utils.py

*** Variables ***
${TAB_TEMPLATE}   ${CURDIR}${/}tableau_template.html
${TAB_WIP_HTML}   ${OUTPUT_DIR}${/}tableau.html
${TAB_VIEW}       OCONUSFederalSpendLite20Q4A/Strategic
${TAB_SHEET_DEFAULT}      Top 10 Contracting Agencies  #AOR Distribution Spend  #Spend and Actions Map
${MAX_TAB_ROWS}       10  # use 0 to get all rows
${PAGE_LOAD_TIMEOUT}  15s
${DATA_GET_TIMEOUT}  30s
${OUT_JSON}       ${OUTPUT_DIR}${/}out.json

*** Keywords ***
Copy Template To Work Version
    ${content}=   Get File   ${TAB_TEMPLATE}
    ${content}=   Replace String  ${content}  __TAB_VIEW__  %{TAB_VIEW=${TAB_VIEW}}
    ${content}=   Replace String  ${content}  __TAB_SHEET__  ${TAB_SHEET}
    ${content}=   Replace String  ${content}  __MAX_ROWS__  %{MAX_TAB_ROWS=${MAX_TAB_ROWS}}
    Create File  ${TAB_WIP_HTML}  ${content}

*** Keywords ***
Load Tableau page and Get Data
    Open Available Browser   file://${TAB_WIP_HTML}  headless=True
    Wait Until Element Is Enabled  id:getData  timeout=${PAGE_LOAD_TIMEOUT}
    Click Element  id:getData
    Wait Until Element Is Visible  id:jsonData  timeout=${DATA_GET_TIMEOUT}
    ${text}=  Get Text   id:jsonData
    [Return]  ${text}
    [Teardown]  Close All Browsers

*** Keywords ***
Save Data Into JSON File
    [Arguments]  ${text}
    ${data}=  Convert string to JSON  ${text}
    Log  ${TAB_SHEET}
    ${sortindex}  Set Variable If  "${TAB_SHEET}" == "Spend and Actions Map"  7  2
    ${data}  ${output}=  Sort And Output  ${TAB_SHEET}  ${data}  ${sortindex}
    Log   ${output}   level=WARN
    Save JSON to file    ${data}    ${OUT_JSON}

*** Keywords ***
Get data from Tableau
    Copy Template To Work Version
    ${text}  Load Tableau page and Get Data
    Save Data Into JSON File  ${text}

*** Tasks ***
Get Data From Tableau
    Set Suite Variable  ${TAB_SHEET}   %{TAB_SHEET=${TAB_SHEET_DEFAULT}}
    Get data from Tableau


