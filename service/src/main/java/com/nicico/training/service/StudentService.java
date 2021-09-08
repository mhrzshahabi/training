package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.enums.ExamsType;
import com.nicico.training.iservice.IStudentService;
import com.nicico.training.model.Student;
import com.nicico.training.repository.StudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.tclass.ElsStudentAttendanceListResponse;
import response.tclass.dto.ElsStudentAttendanceInfoDto;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.nicico.copper.common.util.date.DateUtil.convertMiToKh;

@Service
@RequiredArgsConstructor
public class StudentService implements IStudentService {

    private final ModelMapper modelMapper;
    private final StudentDAO studentDAO;
    private final DateUtil dateUtil;

    @Transactional(readOnly = true)
    @Override
    public StudentDTO.Info get(Long id) {
        final Optional<Student> gById = studentDAO.findById(id);
        final Student student = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
        return modelMapper.map(student, StudentDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Student getStudent(Long id) {
        final Optional<Student> gById = studentDAO.findById(id);
        return gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public Student getStudentByPersonnelNo(String personnelNo) {
        final Optional<Student> student = studentDAO.findByPersonnelNo(personnelNo);
        return student.orElse(null);
    }

    @Transactional(readOnly = true)
    public List<Student> getStudentByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName) {
        List<Student> list = studentDAO.findByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(postId, personnelNo, depId, fName, lName);
        return list;
    }
    @Transactional(readOnly = true)
    public List<Student> getStudentByNationalCode(String nationalCode) {
        List<Student> list = studentDAO.findByNationalCode(nationalCode);
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<StudentDTO.Info> list() {
        final List<Student> gAll = studentDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<StudentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public StudentDTO.Info create(StudentDTO.Create request) {
        final Student student = modelMapper.map(request, Student.class);
        return save(student);
    }

    @Transactional
    @Override
    public StudentDTO.Info update(Long id, StudentDTO.Update request) {
        final Optional<Student> cById = studentDAO.findById(id);
        final Student student = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Student updating = new Student();
        modelMapper.map(student, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        studentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(StudentDTO.Delete request) {
        final List<Student> gAllById = studentDAO.findAllById(request.getIds());
        studentDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<StudentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(studentDAO, request, student -> modelMapper.map(student, StudentDTO.Info.class));
    }

    @Override
    public List<Student> getStudentList(List<Long> absentStudents) {
        List<Student>students=new ArrayList<>();
        for (Long id:absentStudents)
        {
            students.add(getStudent(id));
        }
        return students;
    }

    @Override
    public ElsStudentAttendanceListResponse getStudentAttendanceList(String classCode, String nationalCode) {
        List<Map<String, Object>> result = studentDAO.getStudentAttendanceList(classCode, nationalCode);
        List<ElsStudentAttendanceInfoDto> elsStudentAttendanceInfoDtos = new ArrayList<>();
        ElsStudentAttendanceListResponse elsStudentAttendanceListResponse = new ElsStudentAttendanceListResponse();
        if (result.size() > 0) {
            for (Map<String, Object> map: result) {
                ElsStudentAttendanceInfoDto studentAttInfoDto = new ElsStudentAttendanceInfoDto();
                map.forEach((key, value) -> {
                    if (key.equals("SESSION_DATE")){
                        studentAttInfoDto.setSessionDate(String.valueOf(value));
                    } else if (key.equals("DAY_NAME")){
                        studentAttInfoDto.setSessionWeekDayName(String.valueOf(value));
                    } else if (key.equals("SESSION_START_HOUR")){
                        studentAttInfoDto.setSessionStartHour(String.valueOf(value));
                    } else if (key.equals("SESSION_END_HOUR")){
                        studentAttInfoDto.setSessionEndHour(String.valueOf(value));
                    } else if (key.equals("ATTENDANCE_STATE")){
                        studentAttInfoDto.setAttendanceStateId(Long.parseLong(String.valueOf(value)));
                        switch (String.valueOf(value)){
                            case "0": {
                                studentAttInfoDto.setAttendanceStateTitle("نامشخص");
                                break;
                            }
                            case "1": {
                                studentAttInfoDto.setAttendanceStateTitle("حاضر");
                                break;
                            }
                            case "2": {
                                studentAttInfoDto.setAttendanceStateTitle("حاضر و اضافه کار");
                                break;
                            }
                            case "3": {
                                studentAttInfoDto.setAttendanceStateTitle("غیبت غیر موجه");
                                break;
                            }
                            case "4": {
                                studentAttInfoDto.setAttendanceStateTitle("غیبت موجه");
                                break;
                            }

                        }
                    }
                });
                elsStudentAttendanceInfoDtos.add(studentAttInfoDto);
            }
            elsStudentAttendanceListResponse.setClassCode(classCode);
            elsStudentAttendanceListResponse.setNationalCode(nationalCode);
            elsStudentAttendanceListResponse.setStudentAttendanceInfoDtoList(elsStudentAttendanceInfoDtos);
            elsStudentAttendanceListResponse.setStatus(HttpStatus.OK.value());
        } else {
            elsStudentAttendanceListResponse.setMessage("اطلاعات حضور غیاب برای این کلاس وجود ندارد");
            elsStudentAttendanceListResponse.setStatus(HttpStatus.NO_CONTENT.value());
        }
            return elsStudentAttendanceListResponse;
    }

    // ------------------------------

    private StudentDTO.Info save(Student student) {
        final Student saved = studentDAO.saveAndFlush(student);
        return modelMapper.map(saved, StudentDTO.Info.class);
    }


    @Override
    public List<Map<String, Object>> findAllExamsByNationalCode(String nationalCode, ExamsType type) {
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        if (Boolean.TRUE.equals(type.equals(ExamsType.NOW))){
            String startDate = convertMiToKh(year, month, day);
            return studentDAO.findAllThisDateExamsByNationalCode(nationalCode,startDate);
        }
        if (Boolean.TRUE.equals(type.equals(ExamsType.EXPIRED))){
            String dateCurrent = convertMiToKh(year, month, day);
            DateFormat dateFormat = new SimpleDateFormat("HH:mm");
            Date date = new Date();
            String hour = dateFormat.format(date);
            return studentDAO.findAllExpiredExamsByNationalCode(nationalCode,dateCurrent,hour);
        }
        if (Boolean.TRUE.equals(type.equals(ExamsType.FUTURE))){
            String startDate = convertMiToKh(year, month, day);
            return studentDAO.findAllNextExamsByNationalCode(nationalCode,startDate);
        }
        throw new TrainingException(TrainingException.ErrorType.InvalidData);
    }
}
