*LUCAS RODRIGUES LUZ

**ANÁLISE DESCRITIVA
twoway (scatter IFDMGERAL IFGFgeral)
graph export "C:\Users\l_rod\Desktop\Graph-IFDMGERAL-IFGFGERAL.png", as(png) replace
*VISUALIZAÇÃO GRÁFICA
twoway (scatter IFDMEDUCACAO IFGFInvestimentos, sort)
twoway (scatter IFDMSAÚDE IFGFInvestimentos, sort)
twoway (scatter IFDMSAÚDE IFGFGastoscomPessoal, sort)
twoway (scatter IFDMEDUCACAO IFGFGastoscomPessoal, sort)
twoway (scatter IFDMEDUCACAO IFGFInvestimentos, sort)
*Para o estado de SP
twoway (scatter IFDMGERAL IFGFgeral if UF=="SP")
*Para o estado de CE
twoway (scatter IFDMGERAL IFGFgeral if UF=="CE")
*Realizou-se vários gráficos 
twoway (scatter IFDMGERAL IFGFLiquidez if UF=="CE")
twoway (scatter IFDMEDUCACAO IFGFLiquidez if UF=="CE")
twoway (scatter IFDMGERAL IFGFGastoscomPessoal if UF=="CE")
twoway (scatter IFDMEDUCACAO IFGFGastoscomPessoal if UF=="CE")
*Cálculo de média IFDM
mean IFDMGERAL
mean IFDMGERAL if UF=="CE"
mean IFDMGERAL if UF=="SP"
mean IFDMGERAL IFDMEMPREGOERENDA IFDMSAÚDE IFDMEDUCACAO
mean IFDMGERAL IFDMEMPREGOERENDA IFDMSAÚDE IFDMEDUCACAO if UF=="SP"
mean IFDMGERAL IFDMEMPREGOERENDA IFDMSAÚDE IFDMEDUCACAO if UF=="CE"
*Cálculo de média IFGF
mean IFGFgeral IFGFAutonomia IFGFGastoscomPessoal IFGFLiquidez IFGFInvestimentos
mean IFGFgeral IFGFAutonomia IFGFGastoscomPessoal IFGFLiquidez IFGFInvestimentos if UF=="SP"
mean IFGFgeral IFGFAutonomia IFGFGastoscomPessoal IFGFLiquidez IFGFInvestimentos if UF=="CE"
*Fazendo as definições de painel
xtset id time
*Criando as variáveis de interesse:
*Primeiro para SP
*os Xs do modelo:
gen lnX2=ln(IFGFAutonomia)
gen lnX3=ln(IFGFGastoscomPessoal)
gen lnX4=ln(IFGFLiquidez) 
gen lnX5=ln(IFGFgeral)
gen lnX6=ln(IFGFInvestimentos)
*os Ys do modelo:
*o objetivo é montar 4 modelos separados
gen lnYtgeral=ln(IFDMGERAL/(1-IFDMGERAL))
gen lnYteducacao=ln(IFDMEDUCACAO/(1-IFDMEDUCACAO))
gen lnYtsaude=ln(IFDMSAÚDE/(1-IFDMSAÚDE))
gen lnYtemprego=ln(IFDMEMPREGOERENDA/(1-IFDMEMPREGOERENDA))
*testes de painel:

*Estimador Pooled
reg lnYtgeral lnX2 lnX3 lnX4 lnX5 lnX6

*Estimador de EF
xtreg lnYtgeral lnX2 lnX3 lnX4 lnX5 lnX6, fe
*Deu EF
estimate store efeito_fixo

*Estimador de EA
xtreg lnYtgeral lnX2 lnX3 lnX4 lnX5 lnX6, re
estimate store efeito_aleatorio
*Teste de autocorrelação
xttest0
*Teste de hausman
hausman efeito_fixo efeito_aleatorio

*Os resultados indicaram que o estimador de Efeitos Fixos é mais adequado
xtreg lnYtgeral lnX2 lnX3 lnX4, fe
xtreg lnYtgeral lnX2 lnX3 lnX4 lnX5 lnX6, fe
*Para realizar a interpretação ponto máximo, mínimo e médio
sort time IFDMGERAL
*Os resultados indicaram que o estimador de EF é mais adequado em relação aos estimadores Pooled e EA.
xtreg lnYtgeral lnX2 lnX3 lnX4 lnX6, fe
predict lnYtgeral_estimado1
*Agora, recuperando o nosso Y estimado
gen IFDMgeral_estimado=1/(1+exp(-lnYtgeral_estimado1))
gen eficiencia_relativa=IFDMGERAL/IFDMgeral_estimado
sort time eficiencia_relativa
*Agora para CE é só repetir a programação
drop if Código=="BRASIL"
destring Código, replace
keep if UF=="CE"
gen time=ano
gen id=Código
drop Município
xtset id






