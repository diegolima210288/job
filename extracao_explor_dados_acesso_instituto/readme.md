## Explicação em Português

Neste diretório crio uma consulta, com código SQL, para extrair registro de visitas a um estabelecimento:
 - Nesta consulta faço uso de funções de linha simples como TO_CHAR, CASE e criadas internamente para tratamento dos dados;
 - Também faço uso de INNER JOIN e LEFT JOIN para relacionar dados de diferentes tabelas;
 - E da clausula UNION ALL para unir o resultado de duas consultas.
	
Também neste diretório faço uma análise exploratória sobre os dados obtidos desta consulta, através de recursos das bibliotecas da linguagem Python:
 - No notebook importo as bibliotecas utilizadas nesta exploração;
 - A análise inicial e a normalização dos dados;
 - A distribuição de frequência por cor da pele das pessoas que realizaram a visita;
 - A distribuição de frequência por sexo das pessoas que realizaram a visita;
 - Crosstable entre sexo e cor da pele;
 - E uma analise gráfica:
  - Da quantidade de visitas por mês;
  - Quantidade de visitas por dia da semana, do mês com maior número de visita;
  - Quantidade de visitas por dia da semana, agrupada pela classificação do tipo da pessoa, do mês com maior número de visita;
  - Proporção de visitas por turno (manhã, tarde e noite).
	
	

## Explanation in English

In this directory I create a query, with SQL code, to extract records of visits to an establishment:
 - In this query I use simple line functions such as TO_CHAR, CASE and created internally to process the data;
 - I also use INNER JOIN and LEFT JOIN to relate data from different tables;
 - And the UNION ALL clause to join the results of two queries.

Also in this directory I perform an exploratory analysis of the data obtained from this query, using resources from the Python language libraries:
 - In the notebook I import the libraries used in this exploration;
 - Initial analysis and data normalization;
 - Frequency distribution by skin color of the people who made the visit;
 - Frequency distribution by sex of people who carried out the visit;
 - Crosstable between sex and skin color;
 - And a graphical analysis:
  - The number of visits per month;
  - Number of visits per day of the week, in the month with the highest number of visits;
  - Number of visits per day of the week, grouped by the classification of the person's type, the month with the highest number of visits;
  - Proportion of visits per shift (morning, afternoon and night).
