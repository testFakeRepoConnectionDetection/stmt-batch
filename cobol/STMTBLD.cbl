       IDENTIFICATION DIVISION.
       PROGRAM-ID. STMTBLD.
      *----------------------------------------------------------------
      * BUILDS ONE STATEMENT PER ACCOUNT OF THE DAILY EXTRACT.
      * CREDIT LIMIT AND CURRENT BALANCE ARE READ FROM THE CARD ACCOUNT.
      *----------------------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCT-IN   ASSIGN TO ACCTIN.
           SELECT STMT-OUT  ASSIGN TO STMTOUT.
       DATA DIVISION.
       FILE SECTION.
       FD  ACCT-IN.
       01  ACCT-REC.
           05 ACCT-ID            PIC X(20).
           05 ACCT-CUST-ID       PIC X(20).
           05 FILLER             PIC X(360).
       FD  STMT-OUT.
       01  STMT-LINE             PIC X(2000).
       WORKING-STORAGE SECTION.
           EXEC SQL INCLUDE SQLCA END-EXEC.
       01  WS-LIMIT              PIC S9(10)V99 COMP-3.
       01  WS-BALANCE            PIC S9(10)V99 COMP-3.
       01  WS-EOF                PIC X VALUE 'N'.
       PROCEDURE DIVISION.
       MAIN-PARA.
           OPEN INPUT ACCT-IN OUTPUT STMT-OUT
           PERFORM UNTIL WS-EOF = 'Y'
               READ ACCT-IN AT END MOVE 'Y' TO WS-EOF
                   NOT AT END PERFORM BUILD-ONE
               END-READ
           END-PERFORM
           CLOSE ACCT-IN STMT-OUT
           STOP RUN.
       BUILD-ONE.
           EXEC SQL
               SELECT CREDIT_LIMIT, BALANCE
                 INTO :WS-LIMIT, :WS-BALANCE
                 FROM ISSUING.CARD_ACCOUNT
                WHERE ACCOUNT_ID = :ACCT-ID
           END-EXEC
           PERFORM FORMAT-STATEMENT.
       FORMAT-STATEMENT.
           MOVE SPACES TO STMT-LINE
           WRITE STMT-LINE.
