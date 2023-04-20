
#Zadefinovanie kniznic alebo inych filov ktore chceme pouzivat
*** Settings ***
Library  Browser
Resource  ../resources/common_keywords.robot
Resource  ../resources/variables.robot

#Premenne ktore sa budu pouzivat len v danom file
*** Variables ***
${dummy_variable}=  specific keyword variable


#Samotne keywords pre danu funkcionalitu
*** Keywords ***
Login to GIS
    [Documentation]  Prihlasenie do aplikacie
    [Arguments]  ${application}

    Set Log Level    INFO
    ${viewport}=  Create Dictionary   height=1920   width=1080
    Browser.New Context     acceptDownloads=${True}     viewport=${viewport}
    ${baseUrl}=  Set Variable  https://${application}.greyson.eu/

    Browser.New Page    ${baseURL}
    Sleep  2s

    Browser.Wait for elements state     xpath=//*[text()='Log in via Google']  visible  15s
    Browser.Click    xpath=//*[text()='Log in via Google']
    Sleep  2s
    Browser.Switch Page     NEW

    Browser.Wait for elements state    xpath=//input[@id='identifierId']  visible  15s
    Browser.Fill text   xpath=//input[@id='identifierId']  ${login}
    Browser.Click    xpath=//*[text()='Ďalej']
    Browser.Wait for elements state    xpath=//*[text()='Vitajte']  visible  15s
    Browser.Fill text   xpath=//input[@aria-label='Zadajte svoje heslo']  ${password}
    Browser.Click    xpath=//*[text()='Ďalej']
    #Sleep  100s
    Browser.Wait for elements state    xpath=//*[text()='GREYSON PORTAL']  visible  15s
    Log To Console      Login : OK


Test Teardown Keyword
    [Documentation]  Po skonceni testu ukonci

    Close Browser