DECLARE
CURSOR c_loc is SELECT location_id, city FROM LOCATIONS ORDER BY city;
        r_loc c_loc%rowtype;

CURSOR c_dep(p_locid departments.location_id%type)
    is SELECT department_id, department_name from departments 
        WHERE location_id = p_locid
        ORDER BY department_name;
        r_dep c_dep%rowtype;
        
CURSOR c_emp(p_depid employees.department_id%type)
    is SELECT employee_id, first_name || ' ' || last_name as ad_soyad, hire_date, job_id
    FROM EMPLOYEES
    WHERE department_id = p_depid
    ORDER BY employee_id;
    r_emp c_emp%rowtype;
BEGIN
    open c_loc;
    loop
        fetch c_loc into r_loc;
        EXIT WHEN c_loc%notfound;
        dbms_output.put_line('- location: ' || r_loc.city || 'location id(' || r_loc.location_id || ')');
        
        open c_dep(r_loc.location_id);
            LOOP
                FETCH c_dep into r_dep;
                EXIT WHEN c_dep%notfound;
                dbms_output.put_line('      -- department name: ' || r_dep.department_name || 'department id(' || r_dep.department_id || ')' );
                
                OPEN c_emp(r_dep.department_id);
                    LOOP
                        FETCH c_emp into r_emp;
                        EXIT WHEN c_emp%notfound;
                        dbms_output.put_line('         --- EMPLOYEES ---');
                        dbms_output.put_line('          ' || r_emp.ad_soyad ||
                         ' (' || r_emp.employee_id ||')' || 
                         '-' || r_emp.job_id || ' - ' || r_emp.hire_date);
                    END LOOP;
                CLOSE c_emp;
            END LOOP;
        close c_dep;
        dbms_output.new_line;
    end loop;
    close c_loc;
END;