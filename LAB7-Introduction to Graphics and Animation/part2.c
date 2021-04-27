#include <stdbool.h>
volatile int pixel_buffer_start; // global variable
void clear_screen();
void draw_line(int x_begin, int y_begin, int x_end,int y_end,short int line_color);
void plot_pixel(int x, int y, short int line_color);
void wait();

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen();
	
	while(1){
		for(int y_current=0;y_current<=239;y_current++){
			draw_line(0,y_current,319,y_current,0x001F);
			wait();
			draw_line(0,y_current,319,y_current,0x0000);
		}
		for(int y_current=239;y_current>=0;y_current--){
			draw_line(0,y_current,319,y_current,0x001F);
			wait();
			draw_line(0,y_current,319,y_current,0x0000);
		}
	}
    return 0;
}

void swap(int * x, int * y){
    int temp = *x;
    *x = *y;
    *y = temp;   
}
void wait(){
	volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    volatile int * status =(int *)0xFF20302C;
	//make the request for the swap:
	*pixel_ctrl_ptr = 1; //write 1 to the front buffer register, doesn’t change it, is a signal
	while ((*status & 0x01) != 0) { //polling loop in C! It is a bit wise AND
		status = status;
	}
	//exit loop when S is 1
}
 

void clear_screen(){
	for(int x=0;x<=320;x++){
		for(int y=0;y<=240;y++){
			plot_pixel(x,y,0x0000);
		}
	}
}

void plot_pixel(int x, int y, short int line_color){
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}


void draw_line(int x_begin, int y_begin, int x_end,int y_end,short int line_color){
	bool is_steep = abs(y_end-y_begin) > abs(x_end-x_begin);
	if(is_steep){
		swap(&x_begin,&y_begin);
		swap(&x_end,&y_end);
	}
	if(x_begin>x_end){
		swap(&x_begin,&x_end);
		swap(&y_begin,&y_end);
	}
	
	int deltax = x_end - x_begin;
	int deltay = abs(y_end - y_begin);
    int error = -(deltax / 2);
    int y = y_begin;
	int y_step;
	
	if(y_begin < y_end){
		y_step = 1;
	}
	else{
		y_step = -1;
	}
	
	for(int x_count = x_begin;x_count <= x_end;x_count++){
		if(is_steep){
			plot_pixel(y,x_count,line_color);
		}
		else{
			plot_pixel(x_count,y,line_color);
		}
		error += deltay;
		if(error>=0){
			y += y_step;
			error = error - deltax;
		}
	}
}
