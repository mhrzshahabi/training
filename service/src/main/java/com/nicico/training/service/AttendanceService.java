package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.iservice.IAttendanceService;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AttendanceService implements IAttendanceService {

    private final ModelMapper modelMapper;
    private final AttendanceDAO attendanceDAO;
    private final TclassService tclassService;
    private final ClassSessionService classSessionService;


    @Transactional(readOnly = true)
    @Override
    public AttendanceDTO.Info get(Long id) {
        final Optional<Attendance> sById = attendanceDAO.findById(id);
        final Attendance attendance = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AttendanceNotFound));
        return modelMapper.map(attendance, AttendanceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AttendanceDTO.Info> list() {
        final List<Attendance> sAll = attendanceDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<AttendanceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AttendanceDTO.Info create(AttendanceDTO.Create request) {
        final Attendance attendance = modelMapper.map(request, Attendance.class);
        return save(attendance);
    }

    @Transactional
    @Override
    public List<AttendanceDTO.Info> autoCreate(Long classId, String date) {
        List<ClassSessionDTO.Info> sessions = classSessionService.getSessionsForDate(classId, date);
        Tclass tclass = tclassService.getEntity(classId);
        List<Student> students = tclass.getStudentSet();
        List<Attendance> attendanceList = new ArrayList<>();
        for (ClassSessionDTO.Info session : sessions) {
            for (Student student : students) {
                Attendance attendance = new Attendance();
                attendance.setSessionId(session.getId());
                attendance.setStudentId(student.getId());
                attendanceList.add(attendanceDAO.saveAndFlush(attendance));
            }
        }
        return modelMapper.map(attendanceList, new TypeToken<List<AttendanceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AttendanceDTO.Info update(Long id, AttendanceDTO.Update request) {
        final Optional<Attendance> sById = attendanceDAO.findById(id);
        final Attendance attendance = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AttendanceNotFound));
        Attendance updating = new Attendance();
        modelMapper.map(attendance, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        attendanceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(AttendanceDTO.Delete request) {
        final List<Attendance> sAllById = attendanceDAO.findAllById(request.getIds());
        attendanceDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AttendanceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(attendanceDAO, request, attendance -> modelMapper.map(attendance, AttendanceDTO.Info.class));
    }

    // ------------------------------

    private AttendanceDTO.Info save(Attendance attendance) {

        final Attendance saved = attendanceDAO.saveAndFlush(attendance);
        return modelMapper.map(saved, AttendanceDTO.Info.class);
    }
}
