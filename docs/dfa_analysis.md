# Анализ потока данных (Def-Use) для `process_transaction`

Нумерация строк фрагмента (с учётом пустых строк):

```python
1  def process_transaction(user_id, amount, db_connection):
2      log_entry = "Start processing"
3
4      if amount > 0:
5          status = "approved"
6          balance = get_balance(user_id)
7          new_balance = balance - amount
8          update_balance(user_id, new_balance)
9
10     log_entry = "Transaction finished with status: " + status
11
12     file = open("audit_log.txt", "w")
13     file.write(log_entry)
14
15     return status
```

## Цепочки Def-Use

Переменная: user_id
- Def: строка 1 (параметр функции)
- Use: строка 6 (`get_balance(user_id)`), строка 8 (`update_balance(user_id, new_balance)`)

Переменная: amount
- Def: строка 1 (параметр функции)
- Use: строка 4 (условие `amount > 0`), строка 7 (`balance - amount`)

Переменная: db_connection
- Def: строка 1 (параметр функции)
- Use: нет (параметр нигде не используется)

Переменная: log_entry
- Def: строка 2 (`log_entry = "Start processing"`), строка 10 (`log_entry = "Transaction finished with status: " + status`)
- Use: строка 13 (`file.write(log_entry)`)
- Определение из строки 2 до использования всегда перезаписывается в строке 10.

Переменная: status
- Def: строка 5 (`status = "approved"`, только если `amount > 0`)
- Use: строка 10 (использование в конкатенации строки), строка 15 (`return status`)

Переменная: balance
- Def: строка 6 (`balance = get_balance(user_id)`)
- Use: строка 7 (`new_balance = balance - amount`)

Переменная: new_balance
- Def: строка 7 (`new_balance = balance - amount`)
- Use: строка 8 (`update_balance(user_id, new_balance)`)

Переменная: file
- Def: строка 12 (`file = open("audit_log.txt", "w")`)
- Use: строка 13 (`file.write(log_entry)`)
- Закрытия (`file.close()`) нет: ресурс освобождается только сборщиком мусора.

## Аномалии потока данных

1. `status`: использование без определения при `amount <= 0` (строки 10 и 15).
2. `log_entry`: определение в строке 2 не используется (Dead Store).
3. `file`: определён (ресурс захвачен) в строке 12, но не освобождается.
4. `db_connection`: параметр определён, но не используется.
