## MacOS
Get sensor data
```bash
sudo powermetrics --samplers smc -i1 -n1
```
Get cpu temperature
```bash
sudo powermetrics --samplers smc -i2 -n2 | grep 'CPU die temperature'
```
