CREATE TABLE marcas  (
mrc_id int auto_increment primary key,
mrc_nome varchar(50) not null,
mrc_nacionalidade varchar(50)
);

create table produtos (
prd_id int auto_increment primary key,
prd_nome varchar(50) not null,
prd_qtd_estoque int not null default 0,
prd_estoque_min int not null default 0,
prd_data_fabricacao timestamp default now(),
prd_perecivel boolean,
prd_valor decimal(10,2),

prd_marca_id int,
constraint fk_marcas foreign key(prd_marca_id) references marcas(mrc_id)
);

create table fornecedores (
frn_id int auto_increment primary key,
frn_nome varchar(50) not null,
frn_email varchar(50)
);

create table produto_fornecedor (
pf_prod_id int references produtos (prd_id),
pf_forn_id int references fornecedores(frn_id),

primary key (pf_prod_id, pf_forn_id)
);

insert into marcas (mrc_nome, mrc_nacionalidade) values
('Nike', 'Americana'),	
('Adidas', 'Alemã'),
('Toyota', 'Japonesa'),
('Iveco', 'Italiana'),
('Nestlé', 'Suíça'),
('Tio João', 'Brasileira'),
('Monster', 'Americana'),
('Wickbold', 'Brasileira');

insert into produtos (prd_nome, prd_qtd_estoque, prd_estoque_min, prd_perecivel, prd_valor) values
('Skate', 100, 10, FALSE, 199.99),
('Camiseta esportiva', 50, 5, FALSE, 49.90),
('iPhone', 30, 2, FALSE, 2999.00),
('Café', 200, 20, TRUE, 4.50),
('Controle PS4', 150, 15, FALSE, 12.99);

insert into fornecedores (frn_nome, frn_email) values 
('Fornecedor Tech Solutions', 'info@techsolutions.com'),
('Excelente Distribuidora', 'contato@excelente.com'),
('Suprimentos Rápidos Ltda.', 'suporte@suprimentosrapidos.com'),
('Paradise Imports', 'info@paradiseimports.net'),
('Global Trading Co.', 'contato@globaltradingco.com'),
('Inovação Tech Corp.', 'contato@inovacaotechcorp.com'),
('Distribuidora Veloz', 'info@distribuidoraveloz.com'),
('Soluciona Suprimentos', 'suporte@solucionasuprimentos.com');

insert into produto_fornecedor (pf_prod_id, pf_forn_id) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

create view ProdutosEMarcas as select prd_nome, mrc_nome from produtos join marcas on produtos.prd_id = marcas.mrc_id;
create view ProdutosEFornecedores as select prd.prd_id as produto_id, prd.prd_nome as produto_nome, frn.frn_id as fornecedor_id, frn.frn_nome as fornecedor_nome from produtos prd join produto_fornecedor pf on prd.prd_id = pf.pf_prod_id join fornecedores frn on pf.pf_forn_id = frn.frn_id;

create view PFM as select prd_nome as Produto, frn_nome as Fornecedor, mrc_nome as Marca_nacion from produtos 
left join produto_fornecedor on produtos.prd_id = produto_fornecedor.pf_prod_id 
left join fornecedores on produto_fornecedor.pf_forn_id = fornecedores.frn_id 
left join marcas on produtos.prd_marca_id = marcas.mrc_nacionalidade;

create view ProdutosAbaixoMin as select prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min from produtos where prd_qtd_estoque < prd_estoque_min;
alter table produtos add data_validade date;

insert into produtos (prd_nome, prd_qtd_estoque, prd_estoque_min, prd_perecivel, prd_valor, data_validade) values
('Feijão fradinho', 200, 20, FALSE, 5.99, '2024-08-31'),
('Iogurte Natural', 150, 15, TRUE, 3.50, '2024-07-15'),
('Farinha de trigo', 100, 10, FALSE, 2.99, '2024-06-30');

create view ProdutosComValidadeVencida AS SELECT prd.prd_id, prd.prd_nome AS produto, prd.data_validade, mrc.mrc_nome AS marca FROM produtos prd JOIN marcas mrc ON prd.prd_marca_id = mrc.mrc_id WHERE prd.data_validade < CURRENT_DATE();
select prd_id, prd_nome, prd_valor from produtos where prd_valor > (select avg(prd_valor) from produtos);