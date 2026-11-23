using {car.rental as db} from '../db/schema';

// 1. Definição do Serviço (Cria as rotas /odata/v4/rental/Cars e /odata/v4/rental/Rentals)
service RentalService @(path: '/odata/v4/rental') {
  entity Cars    as projection on db.Cars;
  entity Rentals as projection on db.Rentals;
};

// 2. Anotações Fiori Elements (Ensina o Fiori a desenhar a tela sem precisar programar HTML/JS)
annotate RentalService.Cars with @(
  // Define quais colunas aparecem na tabela principal (List Report)
  UI.LineItem  : [
    {
      Value: brand,
      Label: 'Marca'
    },
    {
      Value: model,
      Label: 'Modelo'
    },
    {
      Value: plate,
      Label: 'Placa'
    },
    {
      Value: dailyRate,
      Label: 'Diária (R$)'
    },
    {
      Value: status,
      Label: 'Status'
    }
  ],
  // Define o título da página de detalhes ao clicar em um carro (Object Page)
  Ui.HeaderInfo: {
    TypeName      : 'Carro',
    TypeNamePlural: 'Frota de Carros',
    Title         : {Value: model},
    Description   : {Value: brand}
  }
);
