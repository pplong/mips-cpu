/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.3.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QDial>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QProgressBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QScrollBar>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTabWidget>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QPushButton *Bopen;
    QLabel *label;
    QLabel *lfname;
    QTabWidget *tabWidget;
    QWidget *tab;
    QPushButton *Bsim;
    QPlainTextEdit *simbox;
    QWidget *tab_2;
    QPushButton *pushButton_8;
    QLabel *label_2;
    QLabel *lsname;
    QPushButton *pushButton_9;
    QPlainTextEdit *Dass_State;
    QLabel *label_3;
    QWidget *tab_3;
    QPlainTextEdit *progbox;
    QPlainTextEdit *OutBox2;
    QPlainTextEdit *OutBox1;
    QLabel *ldass;
    QScrollBar *verticalScrollBar;
    QPushButton *pushButton_10;
    QPushButton *bstep;
    QPushButton *bbreak;
    QLabel *label_4;
    QPlainTextEdit *ecount;
    QTextEdit *mdbox;
    QPushButton *md;
    QSpinBox *md1;
    QSpinBox *md2;
    QLabel *label_5;
    QPushButton *MTR;
    QTextEdit *mtbox;
    QPushButton *MTDD;
    QWidget *tab_5;
    QProgressBar *ib0;
    QLabel *label_6;
    QProgressBar *ib1;
    QLabel *label_7;
    QProgressBar *ib2;
    QProgressBar *ib3;
    QProgressBar *ib5;
    QProgressBar *ib6;
    QProgressBar *ib4;
    QProgressBar *ib7;
    QProgressBar *ib9;
    QProgressBar *ib12;
    QProgressBar *ib13;
    QProgressBar *ib10;
    QProgressBar *ib8;
    QProgressBar *ib14;
    QProgressBar *ib15;
    QProgressBar *ib11;
    QProgressBar *ib26;
    QProgressBar *ib17;
    QProgressBar *ib20;
    QProgressBar *ib28;
    QProgressBar *ib21;
    QProgressBar *ib18;
    QProgressBar *ib16;
    QProgressBar *ib27;
    QProgressBar *ib25;
    QProgressBar *ib24;
    QProgressBar *ib22;
    QProgressBar *ib23;
    QProgressBar *ib19;
    QLabel *label_8;
    QLabel *label_9;
    QLabel *label_10;
    QLabel *label_11;
    QLabel *label_12;
    QLabel *label_13;
    QLabel *label_14;
    QLabel *label_15;
    QLabel *label_16;
    QLabel *label_17;
    QLabel *label_18;
    QLabel *label_19;
    QLabel *label_20;
    QLabel *label_21;
    QLabel *label_22;
    QLabel *label_23;
    QLabel *label_24;
    QLabel *label_25;
    QLabel *label_26;
    QLabel *label_27;
    QLabel *label_28;
    QLabel *label_29;
    QLabel *label_30;
    QLabel *label_31;
    QLabel *label_32;
    QLabel *label_34;
    QLabel *label_35;
    QWidget *tab_4;
    QDial *dial;
    QPushButton *pushButton;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;
    QPushButton *pushButton_6;
    QPushButton *pushButton_7;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->resize(1020, 739);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        Bopen = new QPushButton(centralWidget);
        Bopen->setObjectName(QStringLiteral("Bopen"));
        Bopen->setGeometry(QRect(10, 0, 81, 27));
        label = new QLabel(centralWidget);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(100, 10, 67, 17));
        lfname = new QLabel(centralWidget);
        lfname->setObjectName(QStringLiteral("lfname"));
        lfname->setGeometry(QRect(140, 10, 811, 17));
        tabWidget = new QTabWidget(centralWidget);
        tabWidget->setObjectName(QStringLiteral("tabWidget"));
        tabWidget->setGeometry(QRect(20, 30, 991, 641));
        tab = new QWidget();
        tab->setObjectName(QStringLiteral("tab"));
        Bsim = new QPushButton(tab);
        Bsim->setObjectName(QStringLiteral("Bsim"));
        Bsim->setGeometry(QRect(40, 20, 891, 71));
        simbox = new QPlainTextEdit(tab);
        simbox->setObjectName(QStringLiteral("simbox"));
        simbox->setGeometry(QRect(40, 120, 901, 401));
        tabWidget->addTab(tab, QString());
        tab_2 = new QWidget();
        tab_2->setObjectName(QStringLiteral("tab_2"));
        pushButton_8 = new QPushButton(tab_2);
        pushButton_8->setObjectName(QStringLiteral("pushButton_8"));
        pushButton_8->setGeometry(QRect(30, 20, 99, 27));
        label_2 = new QLabel(tab_2);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setGeometry(QRect(130, 30, 67, 17));
        lsname = new QLabel(tab_2);
        lsname->setObjectName(QStringLiteral("lsname"));
        lsname->setGeometry(QRect(160, 30, 801, 17));
        pushButton_9 = new QPushButton(tab_2);
        pushButton_9->setObjectName(QStringLiteral("pushButton_9"));
        pushButton_9->setEnabled(true);
        pushButton_9->setGeometry(QRect(30, 60, 941, 491));
        Dass_State = new QPlainTextEdit(tab_2);
        Dass_State->setObjectName(QStringLiteral("Dass_State"));
        Dass_State->setGeometry(QRect(80, 560, 291, 31));
        label_3 = new QLabel(tab_2);
        label_3->setObjectName(QStringLiteral("label_3"));
        label_3->setGeometry(QRect(30, 570, 67, 17));
        tabWidget->addTab(tab_2, QString());
        tab_3 = new QWidget();
        tab_3->setObjectName(QStringLiteral("tab_3"));
        progbox = new QPlainTextEdit(tab_3);
        progbox->setObjectName(QStringLiteral("progbox"));
        progbox->setGeometry(QRect(620, 10, 361, 441));
        OutBox2 = new QPlainTextEdit(tab_3);
        OutBox2->setObjectName(QStringLiteral("OutBox2"));
        OutBox2->setGeometry(QRect(10, 280, 581, 171));
        OutBox1 = new QPlainTextEdit(tab_3);
        OutBox1->setObjectName(QStringLiteral("OutBox1"));
        OutBox1->setGeometry(QRect(10, 80, 581, 171));
        ldass = new QLabel(tab_3);
        ldass->setObjectName(QStringLiteral("ldass"));
        ldass->setGeometry(QRect(70, 260, 501, 17));
        verticalScrollBar = new QScrollBar(tab_3);
        verticalScrollBar->setObjectName(QStringLiteral("verticalScrollBar"));
        verticalScrollBar->setGeometry(QRect(50, 260, 16, 16));
        verticalScrollBar->setOrientation(Qt::Vertical);
        pushButton_10 = new QPushButton(tab_3);
        pushButton_10->setObjectName(QStringLiteral("pushButton_10"));
        pushButton_10->setGeometry(QRect(20, 10, 181, 61));
        bstep = new QPushButton(tab_3);
        bstep->setObjectName(QStringLiteral("bstep"));
        bstep->setGeometry(QRect(220, 10, 99, 27));
        bbreak = new QPushButton(tab_3);
        bbreak->setObjectName(QStringLiteral("bbreak"));
        bbreak->setGeometry(QRect(220, 40, 99, 27));
        label_4 = new QLabel(tab_3);
        label_4->setObjectName(QStringLiteral("label_4"));
        label_4->setGeometry(QRect(450, 40, 91, 17));
        ecount = new QPlainTextEdit(tab_3);
        ecount->setObjectName(QStringLiteral("ecount"));
        ecount->setGeometry(QRect(540, 30, 51, 31));
        mdbox = new QTextEdit(tab_3);
        mdbox->setObjectName(QStringLiteral("mdbox"));
        mdbox->setGeometry(QRect(140, 460, 241, 141));
        md = new QPushButton(tab_3);
        md->setObjectName(QStringLiteral("md"));
        md->setGeometry(QRect(10, 460, 121, 27));
        md1 = new QSpinBox(tab_3);
        md1->setObjectName(QStringLiteral("md1"));
        md1->setGeometry(QRect(10, 500, 121, 27));
        md1->setMaximum(1048576);
        md2 = new QSpinBox(tab_3);
        md2->setObjectName(QStringLiteral("md2"));
        md2->setGeometry(QRect(10, 550, 121, 27));
        md2->setMaximum(1048576);
        label_5 = new QLabel(tab_3);
        label_5->setObjectName(QStringLiteral("label_5"));
        label_5->setGeometry(QRect(60, 530, 16, 17));
        MTR = new QPushButton(tab_3);
        MTR->setObjectName(QStringLiteral("MTR"));
        MTR->setGeometry(QRect(420, 500, 99, 27));
        mtbox = new QTextEdit(tab_3);
        mtbox->setObjectName(QStringLiteral("mtbox"));
        mtbox->setGeometry(QRect(530, 460, 241, 141));
        MTDD = new QPushButton(tab_3);
        MTDD->setObjectName(QStringLiteral("MTDD"));
        MTDD->setGeometry(QRect(420, 460, 99, 27));
        tabWidget->addTab(tab_3, QString());
        tab_5 = new QWidget();
        tab_5->setObjectName(QStringLiteral("tab_5"));
        tab_5->setEnabled(true);
        ib0 = new QProgressBar(tab_5);
        ib0->setObjectName(QStringLiteral("ib0"));
        ib0->setGeometry(QRect(10, 20, 21, 521));
        ib0->setLayoutDirection(Qt::LeftToRight);
        ib0->setMaximum(2000);
        ib0->setValue(0);
        ib0->setOrientation(Qt::Vertical);
        label_6 = new QLabel(tab_5);
        label_6->setObjectName(QStringLiteral("label_6"));
        label_6->setGeometry(QRect(10, 550, 21, 17));
        QFont font;
        font.setPointSize(9);
        label_6->setFont(font);
        ib1 = new QProgressBar(tab_5);
        ib1->setObjectName(QStringLiteral("ib1"));
        ib1->setGeometry(QRect(40, 20, 21, 521));
        ib1->setLayoutDirection(Qt::LeftToRight);
        ib1->setMaximum(2000);
        ib1->setValue(0);
        ib1->setOrientation(Qt::Vertical);
        label_7 = new QLabel(tab_5);
        label_7->setObjectName(QStringLiteral("label_7"));
        label_7->setGeometry(QRect(40, 550, 31, 17));
        label_7->setFont(font);
        ib2 = new QProgressBar(tab_5);
        ib2->setObjectName(QStringLiteral("ib2"));
        ib2->setGeometry(QRect(70, 20, 21, 521));
        ib2->setLayoutDirection(Qt::LeftToRight);
        ib2->setMaximum(2000);
        ib2->setValue(0);
        ib2->setOrientation(Qt::Vertical);
        ib3 = new QProgressBar(tab_5);
        ib3->setObjectName(QStringLiteral("ib3"));
        ib3->setGeometry(QRect(100, 20, 21, 521));
        ib3->setLayoutDirection(Qt::LeftToRight);
        ib3->setMaximum(2000);
        ib3->setValue(0);
        ib3->setOrientation(Qt::Vertical);
        ib5 = new QProgressBar(tab_5);
        ib5->setObjectName(QStringLiteral("ib5"));
        ib5->setGeometry(QRect(160, 20, 21, 521));
        ib5->setLayoutDirection(Qt::LeftToRight);
        ib5->setMaximum(2000);
        ib5->setValue(0);
        ib5->setOrientation(Qt::Vertical);
        ib6 = new QProgressBar(tab_5);
        ib6->setObjectName(QStringLiteral("ib6"));
        ib6->setGeometry(QRect(190, 20, 21, 521));
        ib6->setLayoutDirection(Qt::LeftToRight);
        ib6->setMaximum(2000);
        ib6->setValue(0);
        ib6->setOrientation(Qt::Vertical);
        ib4 = new QProgressBar(tab_5);
        ib4->setObjectName(QStringLiteral("ib4"));
        ib4->setGeometry(QRect(130, 20, 21, 521));
        ib4->setLayoutDirection(Qt::LeftToRight);
        ib4->setMaximum(2000);
        ib4->setValue(0);
        ib4->setOrientation(Qt::Vertical);
        ib7 = new QProgressBar(tab_5);
        ib7->setObjectName(QStringLiteral("ib7"));
        ib7->setGeometry(QRect(220, 20, 21, 521));
        ib7->setLayoutDirection(Qt::LeftToRight);
        ib7->setMaximum(2000);
        ib7->setValue(0);
        ib7->setOrientation(Qt::Vertical);
        ib9 = new QProgressBar(tab_5);
        ib9->setObjectName(QStringLiteral("ib9"));
        ib9->setGeometry(QRect(280, 20, 21, 521));
        ib9->setLayoutDirection(Qt::LeftToRight);
        ib9->setMaximum(2000);
        ib9->setValue(0);
        ib9->setOrientation(Qt::Vertical);
        ib12 = new QProgressBar(tab_5);
        ib12->setObjectName(QStringLiteral("ib12"));
        ib12->setGeometry(QRect(370, 20, 21, 521));
        ib12->setLayoutDirection(Qt::LeftToRight);
        ib12->setMaximum(2000);
        ib12->setValue(0);
        ib12->setOrientation(Qt::Vertical);
        ib13 = new QProgressBar(tab_5);
        ib13->setObjectName(QStringLiteral("ib13"));
        ib13->setGeometry(QRect(400, 20, 21, 521));
        ib13->setLayoutDirection(Qt::LeftToRight);
        ib13->setMaximum(2000);
        ib13->setValue(0);
        ib13->setOrientation(Qt::Vertical);
        ib10 = new QProgressBar(tab_5);
        ib10->setObjectName(QStringLiteral("ib10"));
        ib10->setGeometry(QRect(310, 20, 21, 521));
        ib10->setLayoutDirection(Qt::LeftToRight);
        ib10->setMaximum(2000);
        ib10->setValue(0);
        ib10->setOrientation(Qt::Vertical);
        ib8 = new QProgressBar(tab_5);
        ib8->setObjectName(QStringLiteral("ib8"));
        ib8->setGeometry(QRect(250, 20, 21, 521));
        ib8->setLayoutDirection(Qt::LeftToRight);
        ib8->setMaximum(2000);
        ib8->setValue(0);
        ib8->setOrientation(Qt::Vertical);
        ib14 = new QProgressBar(tab_5);
        ib14->setObjectName(QStringLiteral("ib14"));
        ib14->setGeometry(QRect(430, 20, 21, 521));
        ib14->setLayoutDirection(Qt::LeftToRight);
        ib14->setMaximum(2000);
        ib14->setValue(0);
        ib14->setOrientation(Qt::Vertical);
        ib15 = new QProgressBar(tab_5);
        ib15->setObjectName(QStringLiteral("ib15"));
        ib15->setGeometry(QRect(460, 20, 21, 521));
        ib15->setLayoutDirection(Qt::LeftToRight);
        ib15->setMaximum(2000);
        ib15->setValue(0);
        ib15->setOrientation(Qt::Vertical);
        ib11 = new QProgressBar(tab_5);
        ib11->setObjectName(QStringLiteral("ib11"));
        ib11->setGeometry(QRect(340, 20, 21, 521));
        ib11->setLayoutDirection(Qt::LeftToRight);
        ib11->setMaximum(2000);
        ib11->setValue(0);
        ib11->setOrientation(Qt::Vertical);
        ib26 = new QProgressBar(tab_5);
        ib26->setObjectName(QStringLiteral("ib26"));
        ib26->setGeometry(QRect(790, 20, 21, 521));
        ib26->setLayoutDirection(Qt::LeftToRight);
        ib26->setMaximum(2000);
        ib26->setValue(0);
        ib26->setOrientation(Qt::Vertical);
        ib17 = new QProgressBar(tab_5);
        ib17->setObjectName(QStringLiteral("ib17"));
        ib17->setGeometry(QRect(520, 20, 21, 521));
        ib17->setLayoutDirection(Qt::LeftToRight);
        ib17->setMaximum(2000);
        ib17->setValue(0);
        ib17->setOrientation(Qt::Vertical);
        ib20 = new QProgressBar(tab_5);
        ib20->setObjectName(QStringLiteral("ib20"));
        ib20->setGeometry(QRect(610, 20, 21, 521));
        ib20->setLayoutDirection(Qt::LeftToRight);
        ib20->setMaximum(2000);
        ib20->setValue(0);
        ib20->setOrientation(Qt::Vertical);
        ib28 = new QProgressBar(tab_5);
        ib28->setObjectName(QStringLiteral("ib28"));
        ib28->setGeometry(QRect(850, 20, 21, 521));
        ib28->setLayoutDirection(Qt::LeftToRight);
        ib28->setMaximum(2000);
        ib28->setValue(0);
        ib28->setOrientation(Qt::Vertical);
        ib21 = new QProgressBar(tab_5);
        ib21->setObjectName(QStringLiteral("ib21"));
        ib21->setGeometry(QRect(640, 20, 21, 521));
        ib21->setLayoutDirection(Qt::LeftToRight);
        ib21->setMaximum(2000);
        ib21->setValue(0);
        ib21->setOrientation(Qt::Vertical);
        ib18 = new QProgressBar(tab_5);
        ib18->setObjectName(QStringLiteral("ib18"));
        ib18->setGeometry(QRect(550, 20, 21, 521));
        ib18->setLayoutDirection(Qt::LeftToRight);
        ib18->setMaximum(2000);
        ib18->setValue(0);
        ib18->setOrientation(Qt::Vertical);
        ib16 = new QProgressBar(tab_5);
        ib16->setObjectName(QStringLiteral("ib16"));
        ib16->setGeometry(QRect(490, 20, 21, 521));
        ib16->setLayoutDirection(Qt::LeftToRight);
        ib16->setMaximum(2000);
        ib16->setValue(0);
        ib16->setOrientation(Qt::Vertical);
        ib27 = new QProgressBar(tab_5);
        ib27->setObjectName(QStringLiteral("ib27"));
        ib27->setGeometry(QRect(820, 20, 21, 521));
        ib27->setLayoutDirection(Qt::LeftToRight);
        ib27->setMaximum(2000);
        ib27->setValue(0);
        ib27->setOrientation(Qt::Vertical);
        ib25 = new QProgressBar(tab_5);
        ib25->setObjectName(QStringLiteral("ib25"));
        ib25->setGeometry(QRect(760, 20, 21, 521));
        ib25->setLayoutDirection(Qt::LeftToRight);
        ib25->setMaximum(2000);
        ib25->setValue(0);
        ib25->setOrientation(Qt::Vertical);
        ib24 = new QProgressBar(tab_5);
        ib24->setObjectName(QStringLiteral("ib24"));
        ib24->setGeometry(QRect(730, 20, 21, 521));
        ib24->setLayoutDirection(Qt::LeftToRight);
        ib24->setMaximum(2000);
        ib24->setValue(0);
        ib24->setOrientation(Qt::Vertical);
        ib22 = new QProgressBar(tab_5);
        ib22->setObjectName(QStringLiteral("ib22"));
        ib22->setGeometry(QRect(670, 20, 21, 521));
        ib22->setLayoutDirection(Qt::LeftToRight);
        ib22->setMaximum(2000);
        ib22->setValue(0);
        ib22->setOrientation(Qt::Vertical);
        ib23 = new QProgressBar(tab_5);
        ib23->setObjectName(QStringLiteral("ib23"));
        ib23->setGeometry(QRect(700, 20, 21, 521));
        ib23->setLayoutDirection(Qt::LeftToRight);
        ib23->setMaximum(2000);
        ib23->setValue(0);
        ib23->setOrientation(Qt::Vertical);
        ib19 = new QProgressBar(tab_5);
        ib19->setObjectName(QStringLiteral("ib19"));
        ib19->setGeometry(QRect(580, 20, 21, 521));
        ib19->setLayoutDirection(Qt::LeftToRight);
        ib19->setMaximum(2000);
        ib19->setValue(0);
        ib19->setOrientation(Qt::Vertical);
        label_8 = new QLabel(tab_5);
        label_8->setObjectName(QStringLiteral("label_8"));
        label_8->setGeometry(QRect(70, 550, 31, 17));
        label_8->setFont(font);
        label_9 = new QLabel(tab_5);
        label_9->setObjectName(QStringLiteral("label_9"));
        label_9->setGeometry(QRect(100, 550, 31, 17));
        label_9->setFont(font);
        label_10 = new QLabel(tab_5);
        label_10->setObjectName(QStringLiteral("label_10"));
        label_10->setGeometry(QRect(130, 550, 31, 17));
        label_10->setFont(font);
        label_11 = new QLabel(tab_5);
        label_11->setObjectName(QStringLiteral("label_11"));
        label_11->setGeometry(QRect(160, 550, 31, 17));
        label_11->setFont(font);
        label_12 = new QLabel(tab_5);
        label_12->setObjectName(QStringLiteral("label_12"));
        label_12->setGeometry(QRect(190, 550, 31, 17));
        label_12->setFont(font);
        label_13 = new QLabel(tab_5);
        label_13->setObjectName(QStringLiteral("label_13"));
        label_13->setGeometry(QRect(220, 550, 31, 17));
        label_13->setFont(font);
        label_14 = new QLabel(tab_5);
        label_14->setObjectName(QStringLiteral("label_14"));
        label_14->setGeometry(QRect(250, 550, 31, 17));
        label_14->setFont(font);
        label_15 = new QLabel(tab_5);
        label_15->setObjectName(QStringLiteral("label_15"));
        label_15->setGeometry(QRect(280, 550, 31, 17));
        label_15->setFont(font);
        label_16 = new QLabel(tab_5);
        label_16->setObjectName(QStringLiteral("label_16"));
        label_16->setGeometry(QRect(310, 550, 31, 17));
        label_16->setFont(font);
        label_17 = new QLabel(tab_5);
        label_17->setObjectName(QStringLiteral("label_17"));
        label_17->setGeometry(QRect(340, 550, 31, 17));
        label_17->setFont(font);
        label_18 = new QLabel(tab_5);
        label_18->setObjectName(QStringLiteral("label_18"));
        label_18->setGeometry(QRect(380, 550, 31, 17));
        label_18->setFont(font);
        label_19 = new QLabel(tab_5);
        label_19->setObjectName(QStringLiteral("label_19"));
        label_19->setGeometry(QRect(400, 550, 31, 17));
        label_19->setFont(font);
        label_20 = new QLabel(tab_5);
        label_20->setObjectName(QStringLiteral("label_20"));
        label_20->setGeometry(QRect(440, 550, 31, 17));
        label_20->setFont(font);
        label_21 = new QLabel(tab_5);
        label_21->setObjectName(QStringLiteral("label_21"));
        label_21->setGeometry(QRect(460, 550, 31, 17));
        label_21->setFont(font);
        label_22 = new QLabel(tab_5);
        label_22->setObjectName(QStringLiteral("label_22"));
        label_22->setGeometry(QRect(490, 550, 31, 17));
        label_22->setFont(font);
        label_23 = new QLabel(tab_5);
        label_23->setObjectName(QStringLiteral("label_23"));
        label_23->setGeometry(QRect(520, 550, 31, 17));
        label_23->setFont(font);
        label_24 = new QLabel(tab_5);
        label_24->setObjectName(QStringLiteral("label_24"));
        label_24->setGeometry(QRect(550, 550, 31, 17));
        label_24->setFont(font);
        label_25 = new QLabel(tab_5);
        label_25->setObjectName(QStringLiteral("label_25"));
        label_25->setGeometry(QRect(580, 550, 31, 17));
        label_25->setFont(font);
        label_26 = new QLabel(tab_5);
        label_26->setObjectName(QStringLiteral("label_26"));
        label_26->setGeometry(QRect(610, 550, 31, 17));
        label_26->setFont(font);
        label_27 = new QLabel(tab_5);
        label_27->setObjectName(QStringLiteral("label_27"));
        label_27->setGeometry(QRect(630, 550, 31, 17));
        label_27->setFont(font);
        label_28 = new QLabel(tab_5);
        label_28->setObjectName(QStringLiteral("label_28"));
        label_28->setGeometry(QRect(670, 550, 31, 17));
        label_28->setFont(font);
        label_29 = new QLabel(tab_5);
        label_29->setObjectName(QStringLiteral("label_29"));
        label_29->setGeometry(QRect(700, 550, 31, 17));
        label_29->setFont(font);
        label_30 = new QLabel(tab_5);
        label_30->setObjectName(QStringLiteral("label_30"));
        label_30->setGeometry(QRect(730, 550, 31, 17));
        label_30->setFont(font);
        label_31 = new QLabel(tab_5);
        label_31->setObjectName(QStringLiteral("label_31"));
        label_31->setGeometry(QRect(760, 550, 31, 17));
        label_31->setFont(font);
        label_32 = new QLabel(tab_5);
        label_32->setObjectName(QStringLiteral("label_32"));
        label_32->setGeometry(QRect(790, 550, 31, 17));
        label_32->setFont(font);
        label_34 = new QLabel(tab_5);
        label_34->setObjectName(QStringLiteral("label_34"));
        label_34->setGeometry(QRect(850, 550, 31, 17));
        label_34->setFont(font);
        label_35 = new QLabel(tab_5);
        label_35->setObjectName(QStringLiteral("label_35"));
        label_35->setGeometry(QRect(820, 550, 31, 17));
        label_35->setFont(font);
        tabWidget->addTab(tab_5, QString());
        tab_4 = new QWidget();
        tab_4->setObjectName(QStringLiteral("tab_4"));
        dial = new QDial(tab_4);
        dial->setObjectName(QStringLiteral("dial"));
        dial->setGeometry(QRect(0, 80, 311, 291));
        pushButton = new QPushButton(tab_4);
        pushButton->setObjectName(QStringLiteral("pushButton"));
        pushButton->setGeometry(QRect(320, 260, 71, 141));
        pushButton_2 = new QPushButton(tab_4);
        pushButton_2->setObjectName(QStringLiteral("pushButton_2"));
        pushButton_2->setGeometry(QRect(430, 260, 71, 141));
        pushButton_3 = new QPushButton(tab_4);
        pushButton_3->setObjectName(QStringLiteral("pushButton_3"));
        pushButton_3->setGeometry(QRect(550, 260, 71, 141));
        pushButton_4 = new QPushButton(tab_4);
        pushButton_4->setObjectName(QStringLiteral("pushButton_4"));
        pushButton_4->setGeometry(QRect(670, 260, 71, 141));
        pushButton_5 = new QPushButton(tab_4);
        pushButton_5->setObjectName(QStringLiteral("pushButton_5"));
        pushButton_5->setGeometry(QRect(370, 90, 71, 141));
        pushButton_6 = new QPushButton(tab_4);
        pushButton_6->setObjectName(QStringLiteral("pushButton_6"));
        pushButton_6->setGeometry(QRect(490, 90, 71, 141));
        pushButton_7 = new QPushButton(tab_4);
        pushButton_7->setObjectName(QStringLiteral("pushButton_7"));
        pushButton_7->setGeometry(QRect(610, 90, 71, 141));
        tabWidget->addTab(tab_4, QString());
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1020, 25));
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QStringLiteral("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);
        QObject::connect(Bopen, SIGNAL(clicked()), tabWidget, SLOT(show()));
        QObject::connect(pushButton_8, SIGNAL(clicked()), pushButton_9, SLOT(show()));

        tabWidget->setCurrentIndex(1);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0));
        Bopen->setText(QApplication::translate("MainWindow", "Open", 0));
        label->setText(QApplication::translate("MainWindow", "File:", 0));
        lfname->setText(QString());
        Bsim->setText(QApplication::translate("MainWindow", "Simulate", 0));
        tabWidget->setTabText(tabWidget->indexOf(tab), QApplication::translate("MainWindow", "Normal", 0));
        pushButton_8->setText(QApplication::translate("MainWindow", "Save", 0));
        label_2->setText(QApplication::translate("MainWindow", "File:", 0));
        lsname->setText(QString());
        pushButton_9->setText(QApplication::translate("MainWindow", "Do", 0));
        label_3->setText(QApplication::translate("MainWindow", "Status:", 0));
        tabWidget->setTabText(tabWidget->indexOf(tab_2), QApplication::translate("MainWindow", "DisAssem", 0));
        ldass->setText(QString());
        pushButton_10->setText(QApplication::translate("MainWindow", "Initialize", 0));
        bstep->setText(QApplication::translate("MainWindow", "Step", 0));
        bbreak->setText(QApplication::translate("MainWindow", "Break", 0));
        label_4->setText(QApplication::translate("MainWindow", "Exec Count:", 0));
        md->setText(QApplication::translate("MainWindow", "Memory Display", 0));
        label_5->setText(QApplication::translate("MainWindow", "|", 0));
        MTR->setText(QApplication::translate("MainWindow", "MT Reset", 0));
        MTDD->setText(QApplication::translate("MainWindow", "MT Display", 0));
        tabWidget->setTabText(tabWidget->indexOf(tab_3), QApplication::translate("MainWindow", "Step", 0));
        ib0->setFormat(QApplication::translate("MainWindow", "%v", 0));
        label_6->setText(QApplication::translate("MainWindow", "in", 0));
        ib1->setFormat(QApplication::translate("MainWindow", "%v", 0));
        label_7->setText(QApplication::translate("MainWindow", "out", 0));
        ib2->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib3->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib5->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib6->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib4->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib7->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib9->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib12->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib13->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib10->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib8->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib14->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib15->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib11->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib26->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib17->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib20->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib28->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib21->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib18->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib16->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib27->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib25->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib24->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib22->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib23->setFormat(QApplication::translate("MainWindow", "%v", 0));
        ib19->setFormat(QApplication::translate("MainWindow", "%v", 0));
        label_8->setText(QApplication::translate("MainWindow", "sll", 0));
        label_9->setText(QApplication::translate("MainWindow", "srl", 0));
        label_10->setText(QApplication::translate("MainWindow", "and", 0));
        label_11->setText(QApplication::translate("MainWindow", "or", 0));
        label_12->setText(QApplication::translate("MainWindow", "nor", 0));
        label_13->setText(QApplication::translate("MainWindow", "andi", 0));
        label_14->setText(QApplication::translate("MainWindow", "ori", 0));
        label_15->setText(QApplication::translate("MainWindow", "add", 0));
        label_16->setText(QApplication::translate("MainWindow", "sub", 0));
        label_17->setText(QApplication::translate("MainWindow", "addi", 0));
        label_18->setText(QApplication::translate("MainWindow", "jr", 0));
        label_19->setText(QApplication::translate("MainWindow", "slt", 0));
        label_20->setText(QApplication::translate("MainWindow", "j", 0));
        label_21->setText(QApplication::translate("MainWindow", "jal", 0));
        label_22->setText(QApplication::translate("MainWindow", "beq", 0));
        label_23->setText(QApplication::translate("MainWindow", "bne", 0));
        label_24->setText(QApplication::translate("MainWindow", "slti", 0));
        label_25->setText(QApplication::translate("MainWindow", "lw", 0));
        label_26->setText(QApplication::translate("MainWindow", "sw", 0));
        label_27->setText(QApplication::translate("MainWindow", "add.s", 0));
        label_28->setText(QApplication::translate("MainWindow", "sub.s", 0));
        label_29->setText(QApplication::translate("MainWindow", "mul.s", 0));
        label_30->setText(QApplication::translate("MainWindow", "div.s", 0));
        label_31->setText(QApplication::translate("MainWindow", "fslt", 0));
        label_32->setText(QApplication::translate("MainWindow", "feq", 0));
        label_34->setText(QApplication::translate("MainWindow", "swcl", 0));
        label_35->setText(QApplication::translate("MainWindow", "lwcl", 0));
        tabWidget->setTabText(tabWidget->indexOf(tab_5), QApplication::translate("MainWindow", "Analyze", 0));
        pushButton->setText(QString());
        pushButton_2->setText(QString());
        pushButton_3->setText(QString());
        pushButton_4->setText(QString());
        pushButton_5->setText(QString());
        pushButton_6->setText(QString());
        pushButton_7->setText(QString());
        tabWidget->setTabText(tabWidget->indexOf(tab_4), QApplication::translate("MainWindow", "IIDX", 0));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
