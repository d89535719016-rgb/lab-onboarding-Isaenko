# Анализ потока данных (Def-Use)

Переменная: user_id
Def: строка 1 (параметр функции)
Use: строка 6 (get_balance(user_id)), строка 8 (update_balance(user_id, new_balance))

Переменная: amount
Def: строка 1 (параметр функции)
Use: строка 4 (условие amount > 0), строка 7 (balance - amount)

Переменная: db_connection
Def: строка 1 (параметр функции)
Use: нет (параметр не используется)

Переменная: log_entry
Def: строка 2 (log_entry = "Start processing"), строка 10 (log_entry = "Transaction finished with status: " + status)
Use: строка 13 (file.write(log_entry))

Переменная: status
Def: строка 5 (status = "approved", только если amount > 0)
Use: строка 10 (использование в конкатенации строки), строка 15 (return status)

Переменная: balance
Def: строка 6 (balance = get_balance(user_id))
Use: строка 7 (new_balance = balance - amount)

Переменная: new_balance
Def: строка 7 (new_balance = balance - amount)
Use: строка 8 (update_balance(user_id, new_balance))

Переменная: file
Def: строка 12 (file = open("audit_log.txt", "w"))
Use: строка 13 (file.write(log_entry))
