namespace car.rental;

using {cuid, managed} from '@sap/cds/common';

// Tabela auxiliar para opções do Dropdown de Status
entity Statuses {
  key code : String(20);
      name : String(50);
}

// Entidade de Carros (tabela de frota de carros)
entity Cars : cuid, managed {
  model     : String(100) not null;
  brand     : String(50) not null;
  plate     : String(10) not null;
  dailyRate : Decimal(10, 2) not null;
  status    : String(20) default 'AVAILABLE';

  // Um carro pode ter vários historicos de aluguel
  // Regra de ligação (como um JOIN no SQL). Significa: Busque na tabela Rentals todos os aluguéis onde o campo car aponte para mim mesmo ($self, ou seja, o ID deste carro atual)".
  rentals   : Association to many Rentals
                on rentals.car = $self;
}

// Entidade de alugueis (tabela de locacoes)
entity Rentals : cuid, managed {
  customerName : String(100) not null;
  startDate    : Date not null;
  endDate      : Date not null;
  totalPrice   : Decimal(10, 2);

  // Cada aluguel aponta para 1 carro especifico
  // Association to Cars: No banco de dados, o CAP vai criar automaticamente uma coluna chamada car_ID dentro da tabela Rentals para guardar o ID do carro que foi escolhido.
  car          : Association to Cars not null;
}
