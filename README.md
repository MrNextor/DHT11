# DHT11
#### 1-wire bus interface (master) for interrogating the DHT11 digital sensor
Интерфейс шины типа 1-wire (мастер) для опроса цифрового датчика DHT11 (датчик температуры окружающей среды и влажности).
Опрос датчика можно проводить с частотой не менее 1 Гц.  
После инициализации FPGA необходимо вручную сбросить регистры.  
Порядок действий мастера:
1. После сброса мастер устанавливает сигнал O_BUSY в логическую "1".  
2. Спустя 1 секунду мастер устанавливает сигнал O_BUSY в логический "0".  
3. DHT11 готов к опросу. При подаче на мастера сигнала I_EN, мастер начинает опрос DHT11 и устанавливает O_BUSY в логическую "1".  
4. Спустя 1 секунду мастер устанавливает сигнал O_BUSY в логический "0".  
5. Данные температуры и влажности доступны для чтения на двухбайтной шине O_VALUE. Старший байт данных – влажность, младший байт – температура.  
6. DHT11 готов к следующему опросу.
В случае ошибки приема (неверная контрольная сумма принятых данных от DHT11 или отсутствие связи с датчиком), мастер устанавливает O_ERR в логическую "1" и порт O_VALUE во все логические нули.  

*Рисунок 1 - этапы транзакции*
![transaction](https://github.com/MrNextor/DHT11/blob/master/doc/transaction.png)

*Рисунок -  2 диаграмма переходов конечного автомата*  
![master_fsm](https://github.com/MrNextor/DHT11/blob/master/doc/FSM.PNG)
Мастер построен на конечном автомате (модуль dht11_fsm).  
Для отладки мастера написан модуль DHT11_TEST_LEDR.  
+ На LEDR[7:0] выводятся данные температуры (при I_SW) и влажности (!I_SW).  
+ На LEDR[8] сигнал O_BUSY.  
+ На LEDR[9] сигнал O_ERR.  
+ Reset_n осуществляется кнопкой I_KEY[1].  
+ Опрос DHT11 осуществляется кнопкой (!I_KEY[0]).

*Рисунок 3 - температура 29 <sup>o</sup>C с точностью ± 1 <sup>o</sup>C*
![temperature](https://github.com/MrNextor/DHT11/blob/master/doc/temperature_29.jpg)

*Рисунок 4 - влажность 47 % с точностью ± 1 %*
![humidity](https://github.com/MrNextor/DHT11/blob/master/doc/humidity_47.jpg)