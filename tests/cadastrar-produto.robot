*** Comments ***
Especificação de testes para cadastro de produtos no sistema BlueStock.

*** Settings ***
Documentation     Testes de cadastro de produtos no sistema
Library           SeleniumLibrary
Library           OperatingSystem

Test Teardown     Close All Browsers


*** Test Cases ***

Cenário 01 - Cadastrar produto com sucesso
    [Documentation]    Validar cadastro de produto com código exclusivo
    [Tags]    produto    cadastro    positivo

    Given Usuário está autenticado e na página de cadastro de produto
    When Informa um código novo para o produto
    And Informa o nome do produto
    And Seleciona a categoria do produto
    And Informa o preço do produto
    And Informa a quantidade em estoque
    And Seleciona o status do produto
    And Informa a descrição do produto
    And Clica no botão salvar produto
    Then Deve visualizar mensagem de produto cadastrado com sucesso


Cenário 02 - Não deve permitir o cadastro de produtos com o mesmo código
    [Documentation]    Validar bloqueio de cadastro utilizando código já cadastrado
    [Tags]    produto    cadastro    negativo

    Given Usuário está autenticado e na página de cadastro de produto
    When Realiza o cadastro de um produto com código novo
    And Tenta cadastrar outro produto utilizando o mesmo código
    Then Deve visualizar mensagem de código de produto já cadastrado


*** Keywords ***

Usuário está autenticado e na página de cadastro de produto
    Create Directory    evidencias

    Open Browser    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/index.html    chrome
    Maximize Browser Window

    Wait Until Element Is Visible    id=emailLogin    timeout=10s

    Input Text    id=emailLogin    admin@bluestock.com
    Input Text    id=senhaLogin    Admin@123

    Click Button    id=btnEntrar

    Wait Until Page Contains    Consulta de produtos    timeout=10s

    Go To    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/produto-form.html

    Wait Until Element Is Visible    id=codigoProduto    timeout=10s


Informa um código novo para o produto
    ${CODIGO_NOVO}=    Evaluate    'PRD-' + __import__('uuid').uuid4().hex[:12].upper()
    Set Test Variable    ${CODIGO_NOVO}

    Input Text    id=codigoProduto    ${CODIGO_NOVO}


Informa o nome do produto
    Input Text    id=nomeProduto    Notebook QA Automatizado


Seleciona a categoria do produto
    Select From List By Label    id=categoriaProduto    Informática


Informa o preço do produto
    Input Text    id=precoProduto    3500.00


Informa a quantidade em estoque
    Input Text    id=estoqueProduto    10


Seleciona o status do produto
    Select From List By Label    id=statusProduto    Ativo


Informa a descrição do produto
    Input Text    id=descricaoProduto    Produto cadastrado automaticamente pelo Robot Framework.


Clica no botão salvar produto
    Click Button    id=btnSalvarProduto


Deve visualizar mensagem de produto cadastrado com sucesso
    Wait Until Element Is Visible    id=alertaFormularioProduto    timeout=10s

    Element Should Contain
    ...    id=alertaFormularioProduto
    ...    Produto cadastrado com sucesso.

    Capture Page Screenshot    evidencias/cadastrar_produto_sucesso.png


Realiza o cadastro de um produto com código novo
    Informa um código novo para o produto
    Informa o nome do produto
    Seleciona a categoria do produto
    Informa o preço do produto
    Informa a quantidade em estoque
    Seleciona o status do produto
    Informa a descrição do produto

    Clica no botão salvar produto

    Wait Until Element Is Visible    id=alertaFormularioProduto    timeout=10s

    Element Should Contain
    ...    id=alertaFormularioProduto
    ...    Produto cadastrado com sucesso.


Tenta cadastrar outro produto utilizando o mesmo código
    Input Text    id=codigoProduto    ${CODIGO_NOVO}
    Input Text    id=nomeProduto    Segundo Produto QA Automatizado

    Select From List By Label    id=categoriaProduto    Informática

    Input Text    id=precoProduto    2500.00
    Input Text    id=estoqueProduto    5

    Select From List By Label    id=statusProduto    Ativo

    Input Text    id=descricaoProduto    Tentativa de cadastro com código duplicado.

    Clica no botão salvar produto


Deve visualizar mensagem de código de produto já cadastrado
    Wait Until Element Is Visible    id=alertaFormularioProduto    timeout=10s

    Element Should Contain
    ...    id=alertaFormularioProduto
    ...    Já existe um produto com este código.

    Capture Page Screenshot    evidencias/cadastrar_produto_codigo_duplicado.png
