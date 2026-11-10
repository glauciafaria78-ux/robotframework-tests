*** Comments ***
Especificação de teste para consulta de produtos no sistema BlueStock.

*** Settings ***
Documentation     Teste de consulta de produtos cadastrados
Library           SeleniumLibrary
Library           OperatingSystem

Test Teardown     Close All Browsers


*** Test Cases ***

Cenário 01 - Consultar produto com sucesso
    [Documentation]    Validar cadastro e consulta de produto utilizando seu código
    [Tags]    produto    consulta    positivo

    Given Usuário está autenticado no sistema
    When Cadastra um produto com código novo
    And Acessa a página de consulta de produtos
    And Pesquisa o produto pelo código cadastrado
    Then Deve visualizar o produto cadastrado na pesquisa


*** Keywords ***

Usuário está autenticado no sistema
    Create Directory    evidencias

    Open Browser    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/index.html    chrome
    Maximize Browser Window

    Wait Until Element Is Visible    id=emailLogin    timeout=10s

    Input Text    id=emailLogin    admin@bluestock.com
    Input Text    id=senhaLogin    Admin@123

    Click Button    id=btnEntrar

    Wait Until Page Contains    Consulta de produtos    timeout=10s


Cadastra um produto com código novo
    Go To    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/produto-form.html

    Wait Until Element Is Visible    id=codigoProduto    timeout=10s

    ${CODIGO_PRODUTO}=    Evaluate    'PRD-' + __import__('uuid').uuid4().hex[:12].upper()
    Set Test Variable    ${CODIGO_PRODUTO}

    Input Text    id=codigoProduto    ${CODIGO_PRODUTO}
    Input Text    id=nomeProduto    Produto Teste Consulta QA

    Select From List By Label    id=categoriaProduto    Informática

    Input Text    id=precoProduto    3500.00
    Input Text    id=estoqueProduto    10

    Select From List By Label    id=statusProduto    Ativo

    Input Text    id=descricaoProduto    Produto criado automaticamente para teste de consulta.

    Capture Page Screenshot    evidencias/consulta_produto_cadastro.png

    Click Button    id=btnSalvarProduto

    Wait Until Element Is Visible    id=alertaFormularioProduto    timeout=10s

    Element Should Contain
    ...    id=alertaFormularioProduto
    ...    Produto cadastrado com sucesso.


Acessa a página de consulta de produtos
    Go To    https://sergiocotiazure20265-ops.github.io/produtos-cypress-site/produtos.html

    Wait Until Element Is Visible    id=campoBuscaProduto    timeout=10s

    Page Should Contain    Consulta de produtos


Pesquisa o produto pelo código cadastrado
    Input Text    id=campoBuscaProduto    ${CODIGO_PRODUTO}

    Wait Until Element Is Visible    id=linhaProduto-1    timeout=10s


Deve visualizar o produto cadastrado na pesquisa
    Element Should Contain    id=produtoCodigo-1    ${CODIGO_PRODUTO}

    Element Should Contain    id=produtoNome-1    Produto Teste Consulta QA

    Element Should Contain    id=produtoCategoria-1    Informática

    Element Should Contain    id=produtoStatus-1    Ativo

    Capture Page Screenshot    evidencias/consulta_produto_sucesso.png
