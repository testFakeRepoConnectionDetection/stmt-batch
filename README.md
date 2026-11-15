# stmt-batch

Monthly card statements for EMEA: picks up the accounts whose statement day is today, computes
interest and minimum payment, formats the statements and hands them over for printing and for the
e-statement channel.

Runs under the scheduler as job chain STMT010 -> STMT020 -> STMT030 (see `jcl/`).
