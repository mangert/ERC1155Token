# ERC-1155 Token Project (Foundry)

Учебный проект на [Foundry](https://book.getfoundry.sh/), демонстрирующий развёртывание и работу с контрактом ERC-1155.

## 📦 Структура

```bash
.
├── src/
│   ├── ERC1155.sol                   # Основной контракт ERC-1155
│   ├── ERC1155Errors.sol            # Пользовательские ошибки
│   ├── ERC165.sol                   # Реализация интерфейса ERC165
│   └── интерфейсы (IERC1155*.sol)   # Стандартные интерфейсы
├── script/
│   ├── ERC1155.s.sol                # Скрипт деплоя контракта
│   └── ERC1155CreateScript.s.sol   # Скрипт создания/минта токенов
├── broadcast/                       # Артефакты выполнения (в `.gitignore`)
└── README.md
🚀 Развёртывание

    Установите зависимости:

forge install

Установите переменные окружения:

export PRIVATE_KEY=0x...
export SEPOLIA_RPC_URL=https://...
export ETHERSCAN_KEY=...

Деплой контракта:

forge script script/ERC1155.s.sol:ERC1155Script \
  --broadcast \
  --verify \
  --rpc-url "$SEPOLIA_RPC_URL" \
  --etherscan-api-key "$ETHERSCAN_KEY"

Создание токенов:
В скрипте можно указать адрес контракта вручную либо извлечь его из JSON-отчета (если используется ffi).

    forge script script/ERC1155CreateScript.s.sol:ERC1155CreateScript \
      --broadcast \
      --rpc-url "$SEPOLIA_RPC_URL"

🧪 Примечания

    Только владелец контракта может создавать и минтить токены.

    URI токенов указываются напрямую (хранятся на GitHub как JSON).

    Проект не использует OpenZeppelin — реализован вручную для учебных целей.

🛠 Требования

    Foundry (установить через foundryup)

    Аккаунт с балансом ETH в сети Sepolia (например, через faucet)

    RPC URL (Alchemy, Infura и др.)

📄 Лицензия

Учебный проект. Используйте свободно.