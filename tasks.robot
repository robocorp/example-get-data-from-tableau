*** Settings ***
Library    RPA.Browser.Selenium
Library    RPA.JSON
Library    OperatingSystem
Library    String

*** Variables ***
${TAB_TEMPLATE}   ${CURDIR}${/}tableau_template.html
${TAB_WIP_HTML}   ${OUTPUT_DIR}${/}tableau.html
${TAB_VIEW}       OCONUSFederalSpendLite20Q4A/Strategic
${TAB_SHEET}      Spend and Actions Map
${MAX_TAB_ROWS}       20  # use 0 to get all rows
${PAGE_LOAD_TIMEOUT}  15s
${DATA_GET_TIMEOUT}  30s
${OUT_JSON}       ${OUTPUT_DIR}${/}out.json

*** Keywords ***
Copy Template To Work Version
    ${content}   Get File   ${TAB_TEMPLATE}
    ${content}   Replace String  ${content}  __TAB_VIEW__  %{TAB_VIEW=${TAB_VIEW}}
    ${content}   Replace String  ${content}  __TAB_SHEET__  %{TAB_SHEET=${TAB_SHEET}}
    ${content}   Replace String  ${content}  __MAX_ROWS__  %{MAX_TAB_ROWS=${MAX_TAB_ROWS}}
    Create File  ${TAB_WIP_HTML}  ${content}

*** Keywords ***
Load Tableau page and Get Data
    Open Available Browser   file://${TAB_WIP_HTML}  headless=True
    Wait Until Element Is Enabled  id:getData  timeout=${PAGE_LOAD_TIMEOUT}
    Click Element  id:getData
    Wait Until Element Is Visible  id:jsonData  timeout=${DATA_GET_TIMEOUT}
    ${text}  Get Text   id:jsonData
    [Return]  ${text}
    [Teardown]  Close All Browsers

*** Keywords ***
Save Data Into JSON File
    [Arguments]  ${text}
    ${data}  Convert string to JSON  ${text}
    Save JSON to file    ${data}    ${OUT_JSON}

*** Keywords ***
Get data from Tableau
    Copy Template To Work Version
    ${text}  Load Tableau page and Get Data
    Save Data Into JSON File  ${text}

*** Tasks ***
Get Data From Tableau
    Get data from Tableau


