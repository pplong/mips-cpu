#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_Bopen_clicked();

    void on_Bsim_clicked();

    void on_pushButton_8_clicked();

    void on_pushButton_9_clicked();

    void on_pushButton_10_clicked();

    void on_bstep_clicked();

    void on_bbreak_clicked();

    void on_md_clicked();

    void on_MTDD_clicked();

    void on_MTR_clicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
