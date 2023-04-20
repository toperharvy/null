*** Settings ***
Library  Browser

*** Keywords ***
------- BASIC ELEMENT KEYWORDS -------
Wait on element
    [Arguments]  ${xpath}
    Browser.Wait for elements state ${xpath} visible 9Os
    Browser.Hover ${xpath}


Check element
    [Arguments]  ${xpath}
    Browser.Wait for elements state  ${xpath}  visible  90s


Custom click element
    [Arguments]  ${xpath}
    Browser.Wait for elements state  {xpath}  stable  90s
    Browser.Hover  ${xpath}
    Browser.Click  ${xpath}


Enter text
    [Arguments]  ${xpath}
    ...          ${text}

    Browser.Wait for elements state  ${xpath}  visible  90s
    Browser.Hover  ${xpath}
    Fill text  ${xpath}  ${text}


Custom fill text
    [Documentation]  Custom funkcia na vyplnenie textu
    ...              Type : textarea alebo input
    [Arguments]  ${xpath}
    ...          ${text}
    ...          ${type}=input

    IF  '${type}' == 'textarea'
        Custom click element  xpath=//textarea[contains(@id,'${xpath}')]
        Clear text  xpath=//textarea[contains(@id,'${xpath}')]
        Sleep 2
        Fill text  xpath=//textarea[contains(@id,'${xpath}')]  ${text}
    ELSE
        Custom click element  xpath=//input[contains(@id,'${xpath}')]
        Clear text  xpath=//input[contains(@id, '${xpath})]
        Sleep  2
        Fill text  xpath=//input[contains(@id,'${xpath}')]  ${text}
    END


Select from search
    [Documentation]  Kde je pri searchy item v resulte jednoriadkovy
    [Arguments]  ${searchfield_id}
    ...          ${text_to_search}
    ...          ${text_to_click}

    ${input_xpath}=  Set Variable  xpath=//input[contains(@id,'${searchfield_id}')}
    Wait on element  ${input_xpath}
    Custom click element  ${input_xpath}
    Clear Text  ${input_xpath}
    Type text
    ...  ${input_xpath}
    ...  ${text_to_search}
    ...  350 ms
    Sleep  3
    Custom click element  xpath=//span[text ()='${text_to_click}']
    Sleep  2


Select from combobox custom
    [Arguments]  ${combobox_id}
    ...          ${text_to_click}

    Custom click element  xpath=//*[contains(@id,'${combobox_id}')]
    Sleep  5
    Select Options By  //select[contains (@id,'${combobox id}')]  text  ${text to click}
    Wait on element  xpath=//*[contains(@title,'${text_to_click}') and contains(@id,'${combobox_id}')]
    Custom click element  xpath=//*[contains(@id,'${combobox id}')]



------- TIME KEYWORDS -------
Current day +1
    ${currentDay}=  Get Current Date  result_format=%\#d
    IF  ${currentDay} <= 29
        ${plus1day}=  Evaluate  ${currentDay} + 1
    ELSE IF ${currentDay} <= 30
        ${plus1day}=  Set Variable  30
    ELSE
        ${plus1day}=  Set Variable  31
    END
    [return]  ${plus1day}


Compose date
    ${currentDate}=  Get Current Date
    ${currentDate}=  Add Time To Date  ${currentDate}  1day
    ${currentDate}=  Convert Date  ${currentbate}  result_format=%d. %m. %Y
    [return]  ${currentDate}


Current datetime
    ${currentDay}  Get Current Date  result_format=%x-%X
    [return]  ${currentDay}


Current year
    ${currentYear}  Get Current Date  result format=%Y
    [return]  ${currentYear}




------- TEARDOWN KEYWORDS -------
Test Teardown Keyword
    [Documentation]  Po skonceni testu ukonci

    Close Browser


Test Teardown Screenshot Keyword
    [Documentation]  Po skonceni testu ukonci

    Run Keyword If Test Failed    Browser.Take Screenshot  ${OUTPUTDIR}/{index}-${TEST NAME}.png  fullPage=True
    Close Browser