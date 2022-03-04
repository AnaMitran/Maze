module maze(
	input 		          	        clk,
	input       [maze_width - 1:0]  starting_col, starting_row, // indicii punctului de start
	input  			  				     maze_in, 							// ofera informatii despre punctul de coordonate [row, col]
	output reg  [maze_width - 1:0]  row, col,	 						// selecteaza un rând si o coloana din labirint
	output reg			  				  maze_oe,							// output enable (activeaza citirea din labirint la rândul si coloana date) - semnal sincron	
	output reg			  				  maze_we, 							// write enable (activeaza scrierea în labirint la rândul si coloana date) - semnal sincron
	output reg			  				  done);		 						// iesirea din labirint a fost gasita; semnalul ramane activ 
	
	parameter maze_width = 6; //maze de 64x64 cu indicii 0...63
	
	//sens trigonometric
	`define N 0
	`define W 1
	`define S 2	
	`define E 3
	
	reg [1:0] dir, state, next_state;
	
	`define start 0
	`define update 1 
	`define check 2
	
	always @(posedge clk) begin
		if(done == 0) //continui sa verific atata timp cand nu am gasit iesirea
			state <= next_state;
	end
	
	always @(*) begin
		next_state = `start; //starea initiala
		maze_oe = 0;
		maze_we = 0;
		done = 0;
		
		case (state)
		   `start: begin 
				row = starting_row;   //salvez coordonatele punctului de start
				col = starting_col;
				maze_we = 1;          //marchez punctul de start
				dir = `N;             //directia cu care incep verificarea
				
				next_state = `update;
			end
			
			`update: begin	//actualizez pozitia in care ma aflu
				case (dir)
					`N: row = row - 1;
					`W: col = col - 1;
					`S: row = row + 1;
					`E: col = col + 1;
				endcase
				maze_oe = 1; //voi afla cat este valoarea celulei in care m-am mutat
				
				next_state = `check;
			end
				
			`check: begin
				if (maze_in == 1) begin //perete -> ma intorc la pozitia anterioara 
					case (dir)
						`N: row = row + 1;
						`W: col = col + 1;
						`S: row = row - 1;
						`E: col = col - 1;
					endcase
					dir = dir + 1; //verific urmatoarea directie
					
				end else begin //culoar
					maze_we = 1; //marchez drumul
					
					//verific daca am gasit iesirea
					if (row == 63 || row == 0 || col == 63 || col == 0)
						done = 1;
						
					//verific daca am perete in dreapta, folosind directia anterioara
					if (dir == `N) 
						dir = `E; 
					else
						dir = dir - 1;
				end
				
				next_state = `update;
			end	
			
		endcase
	end
	
endmodule





