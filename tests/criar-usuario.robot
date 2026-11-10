*** Comments ***
Especificação de testes para criação de usuários no sistema BlueStock.

*** Settings ***
Documentation     Testes de criação de usuários no sistema
Library           SeleniumLibrary
Library           OperatingSystem

Test Teardown     Close All Browsers


*** Test Cases ***

Cenário 01 - Criar usuário com sucesso
    [Documentation]    Validar criação de usuário com dados válidos e email exclusivo
    [Tags]    cadastro    usuario    positivo

    Given Usuário está na página de cadastro
    When Informa um nome válido
    And Informa um email novo
    And Informa uma senha válida para cadastro
    And Clica no botão cadastrar
    Then Deve visualizar mensagem de cadastro realizado com sucesso


Cenário 02 - Não deve permitir a criação de usuário com email já cadastrado
    [Documentation]    Validar bloqueio de cadastro com email já existente
    [Tags]    cadastro    usuario    negativo

    Given Usuário está na página de cadastro
    When Realiza o cadastro de um usuário com email novo
    And Tenta cadastrar novamente utilizando o mesmo email
    Then Deve visualizar mensagem de email já cadastrado


*** Keywords ***

Usuário está na página de cadastro
    Create Directory    evidencias
    Open Browser    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/cadastro.html    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id=nomeUsuario    timeout=10s


Informa um nome válido
    Input Text    id=nomeUsuario    Usuário QA Automatizado


Informa um email novo
    ${EMAIL_NOVO}=    Evaluate    'qa.' + __import__('uuid').uuid4().hex + '@bluestock.com'
    Set Test Variable    ${EMAIL_NOVO}
    Input Text    id=emailUsuario    ${EMAIL_NOVO}


Informa uma senha válida para cadastro
    Input Text    id=senhaUsuario    Teste@123


Clica no botão cadastrar
    Click Button    id=btnCadastrarUsuario


Deve visualizar mensagem de cadastro realizado com sucesso
    Wait Until Element Is Visible    id=alertaCadastroUsuario    timeout=10s
    Element Should Contain    id=alertaCadastroUsuario    Usuário cadastrado com sucesso. Você já pode fazer login.
    Capture Page Screenshot    evidencias/criar_usuario_sucesso.png


Realiza o cadastro de um usuário com email novo
    Informa um nome válido
    Informa um email novo
    Informa uma senha válida para cadastro
    Clica no botão cadastrar
    Wait Until Element Is Visible    id=alertaCadastroUsuario    timeout=10s
    Element Should Contain    id=alertaCadastroUsuario    Usuário cadastrado com sucesso. Você já pode fazer login.


Tenta cadastrar novamente utilizando o mesmo email
    Informa um nome válido
    Input Text    id=emailUsuario    ${EMAIL_NOVO}
    Informa uma senha válida para cadastro
    Clica no botão cadastrar


Deve visualizar mensagem de email já cadastrado
    Wait Until Element Is Visible    id=alertaCadastroUsuario    timeout=10s
    Element Should Contain    id=alertaCadastroUsuario    Já existe um usuário cadastrado com este e-mail.
    Capture Page Screenshot    evidencias/criar_usuario_email_duplicado.png
