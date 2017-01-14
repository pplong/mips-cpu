#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QPlainTextEdit>
#include <QTextStream>
#include <string.h>
#include "regdef.h"

extern void printreg();
extern void execmode();
extern void dasmode();
extern void dasmode2();
extern void execline(FILE *fp,FILE *inputfp,FILE *outputfp,unsigned line);
extern void dassline(unsigned line);
extern void printreg(char *out);
extern void reginit();
extern void cntinit();

extern unsigned trans_endian(unsigned x);


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->tabWidget->hide();
    ui->pushButton_9->hide();
    prog = (char *)malloc(sizeof(char)*10000);
    out1 = (char *)malloc(sizeof(char)*1000);
    reginit();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_Bopen_clicked()
{
    QString fileName = QFileDialog::getOpenFileName(this,tr("Open File"),"",tr("Text&BinaryFile (*.bin | *.txt);;All Files (*)"));
    if (!fileName.isEmpty() && fileName.length() > 0) {
        setWindowTitle(fileName);
        ui->lfname->setText(fileName);

        int len = fileName.length();
        for (int i = 0;i < len;i++) {
            fname[i] = fileName.data()[i].toLatin1();
        }

        memset(out1,0,sizeof(sizeof(char)*1000));
        memset(prog,0,sizeof(sizeof(char)*10000));
        ui->bstep->hide();
        ui->bbreak->hide();


        cntinit();
        inpc = 0;
    }
}


void MainWindow::on_Bsim_clicked()
{
    ui->simbox->clear();
    cntinit();
    inpc = 0;
    execmode();
    QString qStr = QString::fromLatin1(out1);
    ui->simbox->setPlainText(qStr);
    memset(out1,0,sizeof(char)*1000);


    //Analyze
    unsigned i;
    unsigned isum=0;
    for (i=0;i<29;i++) {
        if (isum < icount[i]) {
            isum = icount[i];
        }
    }
        ui->ib0->setMaximum(isum);
        ui->ib1->setMaximum(isum);
        ui->ib2->setMaximum(isum);
        ui->ib3->setMaximum(isum);
        ui->ib4->setMaximum(isum);
        ui->ib5->setMaximum(isum);
        ui->ib6->setMaximum(isum);
        ui->ib7->setMaximum(isum);
        ui->ib8->setMaximum(isum);
        ui->ib9->setMaximum(isum);
        ui->ib10->setMaximum(isum);
        ui->ib11->setMaximum(isum);
        ui->ib12->setMaximum(isum);
        ui->ib13->setMaximum(isum);
        ui->ib14->setMaximum(isum);
        ui->ib15->setMaximum(isum);
        ui->ib16->setMaximum(isum);
        ui->ib17->setMaximum(isum);
        ui->ib18->setMaximum(isum);
        ui->ib19->setMaximum(isum);
        ui->ib20->setMaximum(isum);
        ui->ib21->setMaximum(isum);
        ui->ib22->setMaximum(isum);
        ui->ib23->setMaximum(isum);
        ui->ib24->setMaximum(isum);
        ui->ib25->setMaximum(isum);
        ui->ib26->setMaximum(isum);
        ui->ib27->setMaximum(isum);
        ui->ib28->setMaximum(isum);


        ui->ib0->setValue(icount[0]);
        ui->ib1->setValue(icount[1]);
        ui->ib2->setValue(icount[2]);
        ui->ib3->setValue(icount[3]);
        ui->ib4->setValue(icount[4]);
        ui->ib5->setValue(icount[5]);
        ui->ib6->setValue(icount[6]);
        ui->ib7->setValue(icount[7]);
        ui->ib8->setValue(icount[8]);
        ui->ib9->setValue(icount[9]);
        ui->ib10->setValue(icount[10]);
        ui->ib11->setValue(icount[11]);
        ui->ib12->setValue(icount[12]);
        ui->ib13->setValue(icount[13]);
        ui->ib14->setValue(icount[14]);
        ui->ib15->setValue(icount[15]);
        ui->ib16->setValue(icount[16]);
        ui->ib17->setValue(icount[17]);
        ui->ib18->setValue(icount[18]);
        ui->ib19->setValue(icount[19]);
        ui->ib20->setValue(icount[20]);
        ui->ib21->setValue(icount[21]);
        ui->ib22->setValue(icount[22]);
        ui->ib23->setValue(icount[23]);
        ui->ib24->setValue(icount[24]);
        ui->ib25->setValue(icount[25]);
        ui->ib26->setValue(icount[26]);
        ui->ib27->setValue(icount[27]);
        ui->ib28->setValue(icount[28]);

        FILE *fpa;
        fpa = fopen("analysis.txt","w");
        int j;
        char buf[10] = {};
        char iname[29][8] =
    {"in","out","sll","srl","and","or","nor","andi","ori","add",
     "sub","addi","jr","slt","j","jal","beq","bne","slti","lw",
     "sw","add.s","sub.s","mul.s","div.s","fslt","feq","lwcl","swcl"};
        for (j=0;j<29;j++){
            sprintf(buf,"%s:%d\n",iname[i],icount[i]);
            fwrite(buf,strlen(buf),1,fpa);
        }


        fclose(fpa);

}

void MainWindow::on_pushButton_8_clicked()
{
    QString fileName = QFileDialog::getSaveFileName(this,
             tr("Save"), "dass.txt",
             tr("Assembly(*.txt);;All Files (*)"));
    ui->lsname->setText(fileName);
    int len = fileName.length();
    for (int i = 0;i < len;i++) {
        aname[i] = fileName.data()[i].toLatin1();
    }
}

void MainWindow::on_pushButton_9_clicked()
{
    ui->Dass_State->clear();
    cntinit();
    dasmode();
    QString qStr = QString::fromLatin1(out1);
    ui->Dass_State->setPlainText(qStr);
    memset(out1,0,sizeof(char)*1000);
}



void MainWindow::on_pushButton_10_clicked()
{
    cntinit();
    memset(out1,0,sizeof(char)*1000);
    memset(prog,0,sizeof(char)*10000);
    ui->progbox->clear();
    ui->OutBox1->clear();
    ui->OutBox2->clear();
    ui->mdbox->clear();
    ui->mtbox->clear();
    stepline = 0;

    dasmode2();
    QString qProg = QString::fromLatin1(prog);
    ui->progbox->setPlainText(qProg);

    printreg(out1);
    QString qOut2 = QString::fromLatin1(out1);
    ui->OutBox2->setPlainText(qOut2);
    pc = 4;
    ui->bstep->show();
    ui->bbreak->show();

    inpc = 0;
    ecount = 0;
    char buf[30];
    ui->ecount->clear();
    sprintf(buf,"%d",ecount);
    QString qEcount = QString::fromLatin1(buf);
    ui->ecount->setPlainText(qEcount);
}

void MainWindow::on_bstep_clicked()
{
    FILE* stepfp;
    FILE *inputfp;
    FILE *outputfp;
    if ((inputfp = fopen("input.bin","rb")) == NULL) {
        inputfp = fopen("input.bin","wb");
        fclose(inputfp);
        inputfp = fopen("input.bin","rb");
    }
    if ((outputfp = fopen("output.bin","wb")) == NULL) {
        printf("Error:Open [output.bin]\n");
    }

    stepfp = fopen(fname,"rb");
    fseek(stepfp,pc,SEEK_SET);
    fseek(inputfp,inpc,SEEK_SET);
    char buf[30];
    if (fread(&stepline,sizeof(int),1,stepfp) == 0) {
        sprintf(out1,"completed\n");
        QString qOut1 = QString::fromLatin1(out1);
        ui->OutBox1->clear();
        ui->OutBox1->setPlainText(qOut1);
        ui->ldass->clear();
        ui->mdbox->clear();
    memset(out1,0,sizeof(char)*1000);
        pc = 0;
        ecount = 0;
        ui->bstep->hide();
        ui->bbreak->hide();
    }
    else {
        QString qOut1 = QString::fromLatin1(out1);
        qOut1 = ui->OutBox2->toPlainText();
        ui->OutBox1->clear();
        ui->OutBox1->setPlainText(qOut1);
    memset(out1,0,sizeof(char)*1000);

        printf("%ld:",(pc-4)/4);
        sprintf(buf,"%ld:",(pc-4)/4);
        dassline(trans_endian(stepline));
        printf("%s\n",cline);
        strcat(buf,cline);
        QString qbody = QString::fromLatin1(buf);
        ui->ldass->setText(qbody);
            execline(stepfp,inputfp,outputfp,trans_endian(stepline));
        pc = ftell(stepfp);
        printreg(out1);

        ui->ecount->clear();
        sprintf(buf,"%d",ecount);
        QString qEcount = QString::fromLatin1(buf);
        ui->ecount->setPlainText(qEcount);
        QString qOut2 = QString::fromLatin1(out1);
        ui->OutBox2->clear();
        ui->OutBox2->setPlainText(qOut2);

        //Memory Display
        unsigned i;
        unsigned madd1,madd2;
        char out[100];
        ui->mdbox->clear();
        madd1 = ui->md1->value();
        madd2 = ui->md2->value();
        if (madd1 >= madd2)
            madd2 = madd1;
        for (i=madd1;i<=madd2;i++) {
            memset(out,0,sizeof(char)*100);
            sprintf(out,"mem[%u]:%d\n",i,maddr[i]);
            QString qmdbox = QString::fromLatin1(out);
            ui->mdbox->insertPlainText(qmdbox);
        }

        memset(out,0,sizeof(char)*100);
        ui->mtbox->clear();
        for (i=0;i<mtnum;i++) {
            memset(out,0,sizeof(char)*100);
            sprintf(out,"mem[%d]:%d\n",mtrace[i],mtracebody[i]);
            QString qmtbox = QString::fromLatin1(out);
            ui->mtbox->insertPlainText(qmtbox);
        }


    }
    bpoint = 0;
    inpc = ftell(inputfp);
    fclose(stepfp);
    fclose(inputfp);
    fclose(outputfp);
}

void MainWindow::on_bbreak_clicked()
{
    FILE *stepfp;
    FILE *inputfp;
    FILE *outputfp;
    if ((inputfp = fopen("input.bin","rb")) == NULL) {
        inputfp = fopen("input.bin","wb");
        fclose(inputfp);
        inputfp = fopen("input.bin","rb");
    }
    if ((outputfp = fopen("output.bin","wb")) == NULL) {
        printf("Error:Open [output.bin]\n");
    }
    stepfp = fopen(fname,"rb");
    fseek(stepfp,pc,SEEK_SET);
    fseek(inputfp,inpc,SEEK_SET);
    char buf[30];
    while(bpoint == 0) {
        if (fread(&stepline,sizeof(int),1,stepfp) == 0) {
            ui->bbreak->hide();
            break;
        }
            steplnum = (pc-4)/4;
            execline(stepfp,inputfp,outputfp,trans_endian(stepline));
            pc = ftell(stepfp);
    }
        pc = ftell(stepfp);
        QString qOut1 = QString::fromLatin1(out1);
        qOut1 = ui->OutBox2->toPlainText();
        ui->OutBox1->clear();
        ui->OutBox1->setPlainText(qOut1);
        memset(out1,0,sizeof(char)*1000);

        bpoint = 0;
        printf("%ld:",steplnum);
        sprintf(buf,"%ld:",steplnum);
        dassline(trans_endian(stepline));
        printf("%s\n",cline);
        strcat(buf,cline);
        QString qbody = QString::fromLatin1(buf);
        ui->ldass->setText(qbody);

        printreg(out1);

        ui->ecount->clear();
        sprintf(buf,"%d",ecount);
        QString qEcount = QString::fromLatin1(buf);
        ui->ecount->setPlainText(qEcount);

        QString qOut2 = QString::fromLatin1(out1);
        ui->OutBox2->clear();
        ui->OutBox2->setPlainText(qOut2);
        inpc = ftell(inputfp);
        fclose(inputfp);
        fclose(outputfp);
        fclose(stepfp);

        //Memory Display
        unsigned i;
        unsigned madd1,madd2;
        char out[100];
        ui->mdbox->clear();
        madd1 = ui->md1->value();
        madd2 = ui->md2->value();
        if (madd1 >= madd2)
            madd2 = madd1;
        for (i=madd1;i<=madd2;i++) {
            memset(out,0,sizeof(char)*100);
            sprintf(out,"mem[%u]:%d\n",i,maddr[i]);
            QString qmdbox = QString::fromLatin1(out);
            ui->mdbox->insertPlainText(qmdbox);
       }
        memset(out,0,sizeof(char)*100);
        ui->mtbox->clear();
        for (i=0;i<mtnum;i++) {
            memset(out,0,sizeof(char)*100);
            sprintf(out,"mem[%d]:%d\n",mtrace[i],mtracebody[i]);
            QString qmtbox = QString::fromLatin1(out);
            ui->mtbox->insertPlainText(qmtbox);
        }
}



void MainWindow::on_md_clicked()
{
    unsigned i;
    unsigned madd1,madd2;
    char out[100];
    ui->mdbox->clear();
    madd1 = ui->md1->value();
    madd2 = ui->md2->value();
    if (madd1 >= madd2)
        madd2 = madd1;
    for (i=madd1;i<=madd2;i++) {
        memset(out,0,sizeof(char)*100);
        sprintf(out,"mem[%u]:%d\n",i,maddr[i]);
        QString qmdbox = QString::fromLatin1(out);
        ui->mdbox->insertPlainText(qmdbox);
    }
}

void MainWindow::on_MTDD_clicked() {
    unsigned i;
    char out[100];
    ui->mtbox->clear();
    for (i=0;i<mtnum;i++) {
        memset(out,0,sizeof(char)*100);
        sprintf(out,"mem[%d]:%d\n",mtrace[i],mtracebody[i]);
        QString qmtbox = QString::fromLatin1(out);
        ui->mtbox->insertPlainText(qmtbox);
    }
}

void MainWindow::on_MTR_clicked()
{
    memset(mtrace,0,mtnum);
    memset(mtracebody,0,mtnum);
    mtnum = 0;
    ui->mtbox->clear();
}
