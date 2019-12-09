package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AttendanceDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface IAttendanceService {

	AttendanceDTO.Info get(Long id);

	List<AttendanceDTO.Info> list();

	AttendanceDTO.Info create(AttendanceDTO.Create request);

	@Transactional
    List<Map<String, String>> autoCreate(Long classId, String date);

    @Transactional
    void convertToModelAndSave(List<Map<String, String>> maps);

    AttendanceDTO.Info update(Long id, AttendanceDTO.Update request);

	void delete(Long id);

	void delete(AttendanceDTO.Delete request);

	SearchDTO.SearchRs<AttendanceDTO.Info> search(SearchDTO.SearchRq request);
}
