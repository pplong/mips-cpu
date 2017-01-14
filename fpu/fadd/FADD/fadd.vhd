library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity部(入出力信号の定義）
entity fadd is
  
  port (
    CLK : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);  -- １つ目の引数
    UINTB : in std_logic_vector(31 downto 0);  -- ２つ目の引数
    UINTC : out std_logic_vector(31 downto 0));  -- 答え
                                             
end fadd;

--architecture部(内部回路の定義)
architecture Behavioral of fadd is

  signal NANA : std_logic;              -- １つ目はNaNか
  signal INFA : std_logic;              -- １つ目はinfか
  signal NANB : std_logic;              -- ２つ目はNaNか
  signal INFB : std_logic;              -- ２つ目はinfか
  signal DENORMALA : std_logic;          -- １つ目は非正規化数か
  signal DENORMALB : std_logic;          -- ２つ目は非正規化数か
  signal ANSWER1,ANSWER2,ANSWER3,ANSWER4,ANSWER5 : unsigned(31 downto 0);  -- 答え
  signal BIG : unsigned(31 downto 0);  --引数のうち大きい方の引数
  signal SMALL : unsigned(31 downto 0);  -- 引数の内小さい方の引数
  signal STICKY : std_logic;            -- 捨てられる部分に１はあるか
  signal BIGFRACTION : unsigned(27 downto 0);  -- 大きい方の引数の仮数部
  signal SMALLFRACTION : unsigned(27 downto 0);  -- 小さい方の引数の仮数部
  signal SMALLFRACTION2 : unsigned(27 downto 0);  -- 小さい仮数部を大きい方に合わせたもの
  signal ANSWERFRACTION1 : unsigned(27 downto 0); -- 調整前の答えの仮数部;
  signal ANSWERFRACTION2 : unsigned(27 downto 0);  -- 調整後の答えの仮数部
  signal ANSWERFRACTION3 : unsigned(27 downto 0);  -- 丸め完成後
  signal ANSWERFRACTION4 : unsigned(27 downto 0);  -- 丸めたあと正規化
  signal ANSWEREXPONENT1 : unsigned(8 downto 0);  -- 答えの指数部分丸め前
  signal ANSWEREXPONENT2 : unsigned(8 downto 0);  -- 答えの指数部分
  signal a1,a2,a3,a4,a5 : std_logic;    -- 答え用のフラグ
  
begin  -- RTL


  NANA<='1' when UINTA(30 downto 23)=x"ff" and (UINTA(22 downto 0)/="00000000000000000000000") else '0';
  NANB<='1' when UINTB(30 downto 23)=x"ff" and (UINTA(22 downto 0)/="00000000000000000000000") else '0';
  INFA<='1' when UINTA(30 downto 23)=x"ff" and UINTA(22 downto 0)="00000000000000000000000" else '0';
  INFB<='1' when UINTB(30 downto 23)=x"ff" and UINTB(22 downto 0)="00000000000000000000000" else '0';
  DENORMALA<='1' when UINTA(30 downto 23)=x"00" else '0';
  DENORMALB<='1' when UINTB(30 downto 23)=x"00" else '0';--NaN,Inf,非正規化数かの判断


  ANSWER1<=x"fff00000" when NANA='1' or NANB='1' else 
            unsigned(UINTA) when INFA='1' and INFB='1' and UINTA(31)=UINTB(31) else 
            x"fff00000" when INFA='1' and INFB='1' else 
            unsigned(UINTA) when INFA='1'  and INFB='0' else 
            unsigned(UINTB) when INFA='0'  and INFB='1' else 
            x"00000000" when DENORMALA='1' and DENORMALB='1' else 
            unsigned(UINTA) when DENORMALB='1' else 
            unsigned(UINTB) when DENORMALA='1' else x"00000000";  --例外処理
  a1<='1' when NANA='1' or NANB='1' or INFA='1' or INFB='1' or DENORMALA='1' or DENORMALB='1' else '0'; 

  BIG<=unsigned(UINTA) when UINTA(30 downto 0)>UINTB(30 downto 0) else unsigned(UINTB);
  SMALL<=unsigned(UINTB) when UINTA(30 downto 0)>UINTB(30 downto 0) else unsigned(UINTA);  -- 引数の大小による並べ替え


  BIGFRACTION<="01" & BIG(22 downto 0) & "000"; 
  SMALLFRACTION<="01" & SMALL(22 downto 0) & "000";  -- 仮数部を抜き出して拡張
      

  SMALLFRACTION2<=SMALLFRACTION when BIG(30 downto 23)-SMALL(30 downto 23)=0 else
 '0' & SMALLFRACTION(27 downto 1) when BIG(30 downto 23)-SMALL(30 downto 23)=1 else
 "00" & SMALLFRACTION(27 downto 2) when BIG(30 downto 23)-SMALL(30 downto 23)=2 else
 "000" & SMALLFRACTION(27 downto 3) when BIG(30 downto 23)-SMALL(30 downto 23)=3 else
 "0000" & SMALLFRACTION(27 downto 4) when BIG(30 downto 23)-SMALL(30 downto 23)=4 else
 "00000" & SMALLFRACTION(27 downto 5) when BIG(30 downto 23)-SMALL(30 downto 23)=5 else
 "000000" & SMALLFRACTION(27 downto 6) when BIG(30 downto 23)-SMALL(30 downto 23)=6 else
 "0000000" & SMALLFRACTION(27 downto 7) when BIG(30 downto 23)-SMALL(30 downto 23)=7 else
 "00000000" & SMALLFRACTION(27 downto 8) when BIG(30 downto 23)-SMALL(30 downto 23)=8 else
 "000000000" & SMALLFRACTION(27 downto 9) when BIG(30 downto 23)-SMALL(30 downto 23)=9 else
 "0000000000" & SMALLFRACTION(27 downto 10) when BIG(30 downto 23)-SMALL(30 downto 23)=10 else
 "00000000000" & SMALLFRACTION(27 downto 11) when BIG(30 downto 23)-SMALL(30 downto 23)=11 else
 "000000000000" & SMALLFRACTION(27 downto 12) when BIG(30 downto 23)-SMALL(30 downto 23)=12 else
 "0000000000000" & SMALLFRACTION(27 downto 13) when BIG(30 downto 23)-SMALL(30 downto 23)=13 else
 "00000000000000" & SMALLFRACTION(27 downto 14) when BIG(30 downto 23)-SMALL(30 downto 23)=14 else
 "000000000000000" & SMALLFRACTION(27 downto 15) when BIG(30 downto 23)-SMALL(30 downto 23)=15 else
 "0000000000000000" & SMALLFRACTION(27 downto 16) when BIG(30 downto 23)-SMALL(30 downto 23)=16 else
 "00000000000000000" & SMALLFRACTION(27 downto 17) when BIG(30 downto 23)-SMALL(30 downto 23)=17 else
 "000000000000000000" & SMALLFRACTION(27 downto 18) when BIG(30 downto 23)-SMALL(30 downto 23)=18 else
 "0000000000000000000" & SMALLFRACTION(27 downto 19) when BIG(30 downto 23)-SMALL(30 downto 23)=19 else
 "00000000000000000000" & SMALLFRACTION(27 downto 20) when BIG(30 downto 23)-SMALL(30 downto 23)=20 else
 "000000000000000000000" & SMALLFRACTION(27 downto 21) when BIG(30 downto 23)-SMALL(30 downto 23)=21 else
 "0000000000000000000000" & SMALLFRACTION(27 downto 22) when BIG(30 downto 23)-SMALL(30 downto 23)=22 else
 "00000000000000000000000" & SMALLFRACTION(27 downto 23) when BIG(30 downto 23)-SMALL(30 downto 23)=23 else
 "000000000000000000000000" & SMALLFRACTION(27 downto 24) when BIG(30 downto 23)-SMALL(30 downto 23)=24 else
 "0000000000000000000000000" & SMALLFRACTION(27 downto 25) when BIG(30 downto 23)-SMALL(30 downto 23)=25;  -- 仮数部を大きい方に合わせる

  ANSWER2<=BIG when BIG(30 downto 23)-SMALL(30 downto 23)>=26 else x"00000000";
  a2<='1' when BIG(30 downto 23)-SMALL(30 downto 23)>=26 else '0';
  
  STICKY<='0' when BIG(30 downto 23)-SMALL(30 downto 23)=0 else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=1 and SMALLFRACTION(1)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=2 and SMALLFRACTION(2)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=3 and SMALLFRACTION(3)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=4 and SMALLFRACTION(4)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=5 and SMALLFRACTION(5)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=6 and SMALLFRACTION(6)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=7 and SMALLFRACTION(7)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=8 and SMALLFRACTION(8)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=9 and SMALLFRACTION(9)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=10 and SMALLFRACTION(10)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=11 and SMALLFRACTION(11)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=12 and SMALLFRACTION(12)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=13 and SMALLFRACTION(13)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=14 and SMALLFRACTION(14)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=15 and SMALLFRACTION(15)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=16 and SMALLFRACTION(16)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=17 and SMALLFRACTION(17)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=18 and SMALLFRACTION(18)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=19 and SMALLFRACTION(19)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=20 and SMALLFRACTION(20)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=21 and SMALLFRACTION(21)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=22 and SMALLFRACTION(22)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=23 and SMALLFRACTION(23)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=24 and SMALLFRACTION(24)='1' else
          '1' when BIG(30 downto 23)-SMALL(30 downto 23)>=25 and SMALLFRACTION(25)='1' else
          '0';                          -- sticky bitのチェック
  
  ANSWERFRACTION1 <= BIGFRACTION+(SMALLFRACTION2(27 downto 1) & sticky) when BIG(31)=SMALL(31) and SMALLFRACTION2(0)='0' else
                    BIGFRACTION+SMALLFRACTION2(27 downto 0) when BIG(31)=SMALL(31) else
                  BIGFRACTION-(SMALLFRACTION2(27 downto 1) & STICKY) when  STICKY='1' else
                  BIGFRACTION-SMALLFRACTION2(27 downto 0) ;
   ANSWERFRACTION2<= ANSWERFRACTION1(27 downto 0) when BIG(31)=SMALL(31) and ANSWERFRACTION1(27)='0' else
                    '0' & ANSWERFRACTION1(27 downto 2) & ANSWERFRACTION1(0) when BIG(31)=SMALL(31) and ANSWERFRACTION1(1)='0'else
                    '0' & ANSWERFRACTION1(27 downto 1) when BIG(31)=SMALL(31) else
                    ANSWERFRACTION1 when ANSWERFRACTION1(26)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(26 downto 0)& '0' when ANSWERFRACTION1(25)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(25 downto 0)& "00" when ANSWERFRACTION1(24)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(24 downto 0)& "000" when ANSWERFRACTION1(23)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(23 downto 0)& "0000" when ANSWERFRACTION1(22)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(22 downto 0)& "00000" when ANSWERFRACTION1(21)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(21 downto 0)& "000000" when ANSWERFRACTION1(20)='1' and  (BIG(31)/=SMALL(31))else
ANSWERFRACTION1(20 downto 0)& "0000000" when ANSWERFRACTION1(19)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(19 downto 0)& "00000000" when ANSWERFRACTION1(18)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(18 downto 0)& "000000000" when ANSWERFRACTION1(17)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(17 downto 0)& "0000000000" when ANSWERFRACTION1(16)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(16 downto 0)& "00000000000" when ANSWERFRACTION1(15)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(15 downto 0)& "000000000000" when ANSWERFRACTION1(14)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(14 downto 0)& "0000000000000" when ANSWERFRACTION1(13)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(13 downto 0)& "00000000000000" when ANSWERFRACTION1(12)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(12 downto 0)& "000000000000000" when ANSWERFRACTION1(11)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(11 downto 0)& "0000000000000000" when ANSWERFRACTION1(10)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(10 downto 0)& "00000000000000000" when ANSWERFRACTION1(9)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(9 downto 0)& "000000000000000000" when ANSWERFRACTION1(8)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(8 downto 0)& "0000000000000000000" when ANSWERFRACTION1(7)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(7 downto 0)& "00000000000000000000" when ANSWERFRACTION1(6)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(6 downto 0)& "000000000000000000000" when ANSWERFRACTION1(5)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(5 downto 0)& "0000000000000000000000" when ANSWERFRACTION1(4)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(4 downto 0)& "00000000000000000000000" when ANSWERFRACTION1(3)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(3 downto 0)& "000000000000000000000000" when ANSWERFRACTION1(2)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(2 downto 0)& "0000000000000000000000000" when ANSWERFRACTION1(1)='1' and (BIG(31)/=SMALL(31)) else
ANSWERFRACTION1(1 downto 0)& "00000000000000000000000000" when ANSWERFRACTION1(0)='1' and (BIG(31)/=SMALL(31));

  ANSWER3<=x"00000000" when ANSWERFRACTION1=0 else x"00000000";
  a3<='1' when ANSWERFRACTION1=0 else '0';
  
   ANSWEREXPONENT1<='0'& BIG(30 downto 23) when BIG(31)=SMALL(31) and ANSWERFRACTION1(27)='0' else
                  ('0' & BIG(30 downto 23))+1 when BIG(31)=SMALL(31) and ANSWERFRACTION1(27)='1' else  -- 符号が一致の計算と正規化 
                 ('0' & BIG(30 downto 23)) when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(26)='1' else
                 ('0' & BIG(30 downto 23))-1 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(25)='1' else
                 ('0' & BIG(30 downto 23))-2 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(24)='1' else
                 ('0' & BIG(30 downto 23))-3 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(23)='1' else
                 ('0' & BIG(30 downto 23))-4 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(22)='1' else
                 ('0' & BIG(30 downto 23))-5 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(21)='1' else
                 ('0' & BIG(30 downto 23))-6 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(20)='1' else
                 ('0' & BIG(30 downto 23))-7 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(19)='1' else
                 ('0' & BIG(30 downto 23))-8 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(18)='1' else
                 ('0' & BIG(30 downto 23))-9 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(17)='1' else
                 ('0' & BIG(30 downto 23))-10 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(16)='1' else
                 ('0' & BIG(30 downto 23))-11 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(15)='1' else
                 ('0' & BIG(30 downto 23))-12 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(14)='1' else
                 ('0' & BIG(30 downto 23))-13 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(13)='1' else
                 ('0' & BIG(30 downto 23))-14 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(12)='1' else
                 ('0' & BIG(30 downto 23))-15 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(11)='1' else
                 ('0' & BIG(30 downto 23))-16 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(10)='1' else
                 ('0' & BIG(30 downto 23))-17 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(9)='1' else
                 ('0' & BIG(30 downto 23))-18 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(8)='1' else
                 ('0' & BIG(30 downto 23))-19 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(7)='1' else
                 ('0' & BIG(30 downto 23))-20 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(6)='1' else
                 ('0' & BIG(30 downto 23))-21 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(5)='1' else
                 ('0' & BIG(30 downto 23))-22 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(4)='1' else
                 ('0' & BIG(30 downto 23))-23 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(3)='1' else
                 ('0' & BIG(30 downto 23))-24 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(2)='1' else
                 ('0' & BIG(30 downto 23))-25 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(1)='1' else
                 ('0' & BIG(30 downto 23))-26 when (BIG(31)/=SMALL(31)) and ANSWERFRACTION1(0)='1' else
                     "000000000";-- 符号が違うときの計算と正規化

  

  ANSWERFRACTION3<=ANSWERFRACTION2+8 when (ANSWERFRACTION2(2)='1' and ((ANSWERFRACTION2(3)='1') or ANSWERFRACTION2(1) ='1' or ANSWERFRACTION2(0)='1') )else ANSWERFRACTION2;
  ANSWERFRACTION4<='0'& ANSWERFRACTION3(27 downto 1) when ANSWERFRACTION3(27)='1' else
                    ANSWERFRACTION3;
  ANSWEREXPONENT2<=ANSWEREXPONENT1+1 when ANSWERFRACTION3(27)='1' else ANSWEREXPONENT1;-- 丸め部分

  
  ANSWER4<=BIG(31) & "1111111100000000000000000000000" when ANSWEREXPONENT2>=255 else
           BIG(31) & "0000000000000000000000000000000" when ANSWEREXPONENT2=0;--オーバーフローアンダーフロー
  a4<='1' when (ANSWEREXPONENT2>=255 or ANSWEREXPONENT2=0)  else '0';
  
  ANSWER5<=BIG(31) & ANSWEREXPONENT2(7 downto 0) & ANSWERFRACTION4(25 downto 3);

  process(clk)
  begin
    if rising_edge(clk) then
      
      --UINTC<=std_logic_vector(ANSWER1) when a1='1' else
      --      std_logic_vector(ANSWER2) when a2='1' else
      --    std_logic_vector(ANSWER3) when a3='1' else
      --   std_logic_vector(ANSWER4) when a4='1' else
      -- std_logic_vector(ANSWER5);

      if a1='1' then UINTC<=std_logic_vector(ANSWER1);
      elsif 
        a2='1' then UINTC<=std_logic_vector(ANSWER2);
      elsif 
        a3='1' then UINTC<=std_logic_vector(ANSWER3);
      elsif
        a4='1' then UINTC<=std_logic_vector(ANSWER4);
      else UINTC<=std_logic_vector(ANSWER5);
           
      end if;
      
    end if;   
  end process;
end Behavioral;
