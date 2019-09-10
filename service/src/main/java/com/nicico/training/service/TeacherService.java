package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.text.html.Option;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

	private final ModelMapper modelMapper;
	private final TeacherDAO teacherDAO;
	private final CategoryDAO categoryDAO;
	private final IPersonalInfoService personalInfoService;
	private final PersonalInfoDAO personalInfoDAO;



    @Value("${nicico.person.upload.dir}")
    private String personUploadDir;

	@Transactional(readOnly = true)
	@Override
	public TeacherDTO.Info get(Long id) {
		final Optional<Teacher> tById = teacherDAO.findById(id);
		final Teacher teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

		return modelMapper.map(teacher, TeacherDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<TeacherDTO.Info> list() {
		final List<Teacher> tAll = teacherDAO.findAll();

		return modelMapper.map(tAll, new TypeToken<List<TeacherDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public TeacherDTO.Info create(TeacherDTO.Create request) {
		Teacher teacher;
		PersonalInfo personalInfo;

		personalInfo = modelMapper.map(request.getPersonality(),PersonalInfo.class);
		List<PersonalInfo> personalInfos = personalInfoDAO.findByNationalCode(request.getPersonality().getNationalCode());

		teacher = modelMapper.map(request, Teacher.class);
		List<Teacher> teachers = teacherDAO.findByTeacherCode(teacher.getTeacherCode());

		if(teachers==null || teachers.size()==0) {
			// person not exist
			if(personalInfos==null || personalInfos.size()==0){
				PersonalInfoDTO.Info personalInfoDTONew = personalInfoService.create(request.getPersonality());
				PersonalInfo personalInfoNew = modelMapper.map(personalInfoDTONew,PersonalInfo.class);
				teacher.setPersonality(personalInfoNew);
				teacher.setPersonalityId(personalInfoNew.getId());
			}
			//person exist
			else{
				PersonalInfoDTO.Info personalInfoDTONew = personalInfoService.update(personalInfos.get(0).getId(), modelMapper.map(personalInfo,PersonalInfoDTO.Update.class));
				PersonalInfo personalInfoNew = modelMapper.map(personalInfoDTONew,PersonalInfo.class);
				teacher.setPersonality(personalInfoNew);
				teacher.setPersonalityId(personalInfoNew.getId());
			}

			return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
		}
		else
			return null;

	}


	@Transactional
	@Override
	public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {
		PersonalInfo personalInfo = modelMapper.map(request.getPersonality(),PersonalInfo.class);
		List<PersonalInfo> personalInfos = personalInfoDAO.findByNationalCode(request.getPersonality().getNationalCode());

		PersonalInfoDTO.Info personalInfoDTONew = personalInfoService.update(personalInfos.get(0).getId(), modelMapper.map(personalInfo,PersonalInfoDTO.Update.class));
		PersonalInfo personalInfoNew = modelMapper.map(personalInfoDTONew,PersonalInfo.class);

		final Optional<Teacher> tById = teacherDAO.findById(id);
        Teacher teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
		Teacher tupdating = new Teacher();

        modelMapper.map(teacher, tupdating);
        modelMapper.map(request, tupdating);
        tupdating.setPersonality(personalInfoNew);
		tupdating.setPersonalityId(personalInfoNew.getId());
        return modelMapper.map(teacherDAO.saveAndFlush(tupdating), TeacherDTO.Info.class);
	}

	@Transactional
	@Override
	public void delete(Long id) {
		teacherDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(TeacherDTO.Delete request) {
		final List<Teacher> tAllById = teacherDAO.findAllById(request.getIds());
		teacherDAO.deleteAll(tAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.Info.class));
	}

	// ------------------------------

	private TeacherDTO.Info save(Teacher teacher) {
		final Teacher saved = teacherDAO.saveAndFlush(teacher);
		return modelMapper.map(saved, TeacherDTO.Info.class);
	}

	@Transactional
    @Override
    public void addCategories(CategoryDTO.Delete request, Long teacherId) {
      	final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

        Set<Category> currents = teacher.getCategories();
        if(currents != null) {
            Object[] currentsArr = currents.toArray();
            for (Object o : currentsArr) {
                teacher.getCategories().remove(o);
            }
        }

        List<Category> gAllById = categoryDAO.findAllById(request.getIds());
        for (Category category : gAllById) {
            teacher.getCategories().add(category);
        }
    }

    @Transactional
    @Override
    public List<Long> getCategories(Long teacherId) {
      	final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        Set<Category> currents = teacher.getCategories();
        List<Long> categories = new ArrayList<Long>();
        for (Category current : currents) {
            categories.add(current.getId());
        }
        return categories;
    }

}
