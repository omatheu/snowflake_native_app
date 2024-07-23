-- Ajuste: Removido "IF NOT EXISTS" e "VERSIONED" pois não são suportados
-- Nota: Certifique-se de que o papel e o esquema não existam ou gerencie a existência deles fora deste script

-- Criação de Role e Schema ajustada para compatibilidade
CREATE ROLE IF NOT EXISTS app_instance_role;
CREATE SCHEMA IF NOT EXISTS app_instance_schema;

-- Concessão de uso do esquema ao papel
GRANT USAGE ON SCHEMA app_instance_schema TO ROLE app_instance_role;

-- Compartilhamento de dados através de uma view
CREATE OR REPLACE VIEW app_instance_schema.REGIONAL_SALES AS SELECT * FROM shared_content_schema.REGIONAL_SALES;

-- Criação de UDFs
CREATE OR REPLACE FUNCTION app_instance_schema.percentage_difference(customer_sales FLOAT, regional_sales FLOAT)
RETURNS FLOAT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
IMPORTS = ('/libraries/udf.py')
HANDLER = 'udf.percentage_difference';

-- Criação de Procedimentos
CREATE OR REPLACE PROCEDURE app_instance_schema.update_reference(ref_name STRING, operation STRING, ref_or_alias STRING)
RETURNS STRING
LANGUAGE SQL
AS $$
BEGIN
  CASE (operation)
    WHEN 'ADD' THEN
      SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
    WHEN 'REMOVE' THEN
      SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
    WHEN 'CLEAR' THEN
      SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
    ELSE
      RETURN 'unknown operation: ' || operation;
  END CASE;
  RETURN 'Operation ' || operation || ' succeeded';
END;
$$;

-- Concessão de uso e permissões sobre objetos
GRANT USAGE ON SCHEMA app_instance_schema TO ROLE app_instance_role;
GRANT SELECT ON VIEW app_instance_schema.REGIONAL_SALES TO ROLE app_instance_role;
-- Ajuste: Removida a linha referente ao Streamlit, pois não é suportada diretamente pelo Snowflake
GRANT USAGE ON PROCEDURE app_instance_schema.update_reference(STRING, STRING, STRING) TO ROLE app_instance_role;