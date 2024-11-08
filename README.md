

to run the state machine unit tests, execute the following command at the root of the project:

```shell
matlab -batch "addpath('src/sm'); results = runtests(fullfile(pwd, 'test', 'sm', 'sm_test.m')); disp(results);"
```





