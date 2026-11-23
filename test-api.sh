#!/bin/bash
# Script de teste das regras de negócio do rental-service
# Uso: bash test-api.sh
# Pré-requisito: cds watch rodando na porta 4004

BASE="http://localhost:4004/odata/v4/rental"

echo "=========================================="
echo "TESTE 1: Listar todos os carros"
echo "=========================================="
curl -s "$BASE/Cars" | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 2: Criar aluguel VÁLIDO (Onix Plus)"
echo "  → Deve calcular totalPrice = 5 * 120 = 600"
echo "=========================================="
curl -s -X POST "$BASE/Rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "car_ID": "11111111-1111-1111-1111-111111111111",
    "customerName": "João Silva",
    "startDate": "2026-12-01",
    "endDate": "2026-12-06"
  }' | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 3: Verificar se Onix mudou para RENTED"
echo "=========================================="
curl -s "$BASE/Cars(11111111-1111-1111-1111-111111111111)" | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 4: Tentar alugar Onix de novo"
echo "  → Deve dar ERRO (já está RENTED)"
echo "=========================================="
curl -s -X POST "$BASE/Rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "car_ID": "11111111-1111-1111-1111-111111111111",
    "customerName": "Maria Souza",
    "startDate": "2026-12-10",
    "endDate": "2026-12-15"
  }' | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 5: Alugar carro em MAINTENANCE (Compass)"
echo "  → Deve dar ERRO (status MAINTENANCE)"
echo "=========================================="
curl -s -X POST "$BASE/Rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "car_ID": "33333333-3333-3333-3333-333333333333",
    "customerName": "Pedro Santos",
    "startDate": "2026-12-01",
    "endDate": "2026-12-05"
  }' | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 6: Data final menor que a inicial"
echo "  → Deve dar ERRO (datas inválidas)"
echo "=========================================="
curl -s -X POST "$BASE/Rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "car_ID": "22222222-2222-2222-2222-222222222222",
    "customerName": "Ana Lima",
    "startDate": "2026-12-10",
    "endDate": "2026-12-05"
  }' | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 7: Sem car_ID"
echo "  → Deve dar ERRO (carro não selecionado)"
echo "=========================================="
curl -s -X POST "$BASE/Rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Carlos Oliveira",
    "startDate": "2026-12-01",
    "endDate": "2026-12-05"
  }' | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTE 8: Listar aluguéis criados"
echo "=========================================="
curl -s "$BASE/Rentals" | python3 -m json.tool
echo ""

echo "=========================================="
echo "TESTES CONCLUÍDOS!"
echo "=========================================="
