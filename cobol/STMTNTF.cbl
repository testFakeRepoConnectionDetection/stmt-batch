       IDENTIFICATION DIVISION.
       PROGRAM-ID. STMTNTF.
      *----------------------------------------------------------------
      * TELLS THE E-STATEMENT CHANNEL THAT TODAY'S STATEMENTS ARE READY.
      *----------------------------------------------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY CMQV.
       01  WS-QMGR               PIC X(48) VALUE 'QMEU01'.
       01  WS-QUEUE              PIC X(48) VALUE 'NOTIF.STMT.READY'.
       01  WS-HCONN              PIC S9(9) BINARY.
       01  WS-HOBJ               PIC S9(9) BINARY.
       01  WS-COMPCODE           PIC S9(9) BINARY.
       01  WS-REASON             PIC S9(9) BINARY.
       01  WS-MESSAGE            PIC X(200).
       01  WS-OD.
           COPY CMQODV.
       PROCEDURE DIVISION.
           CALL 'MQCONN' USING WS-QMGR WS-HCONN WS-COMPCODE WS-REASON
           MOVE WS-QUEUE TO MQOD-OBJECTNAME
           CALL 'MQOPEN' USING WS-HCONN WS-OD MQOO-OUTPUT WS-HOBJ
                               WS-COMPCODE WS-REASON
           MOVE 'STATEMENTS READY' TO WS-MESSAGE
           CALL 'MQPUT1' USING WS-HCONN WS-OD WS-MESSAGE
                               WS-COMPCODE WS-REASON
           CALL 'MQDISC' USING WS-HCONN WS-COMPCODE WS-REASON
           STOP RUN.
