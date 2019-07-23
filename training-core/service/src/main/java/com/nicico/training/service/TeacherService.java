package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

	private final ModelMapper modelMapper;
	private final TeacherDAO teacherDAO;
	private final CategoryDAO categoryDAO;

	private final EnumsConverter.EGenderConverter eGenderConverter = new EnumsConverter.EGenderConverter();
    private final EnumsConverter.EMarriedConverter eMarriedConverter = new EnumsConverter.EMarriedConverter();
    private final EnumsConverter.EMilitaryConverter eMilitaryConverter = new EnumsConverter.EMilitaryConverter();

    @Value("${nicico.teacher.upload.dir}")
    private String teacherUploadDir;

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
		final Teacher teacher = modelMapper.map(request, Teacher.class);

        teacher.setEMarried(eMarriedConverter.convertToEntityAttribute(request.getEMarriedId()));
        teacher.setEMilitary(eMilitaryConverter.convertToEntityAttribute(request.getEMilitaryId()));
        teacher.setEGender(eGenderConverter.convertToEntityAttribute(request.getEGenderId()));

        teacher.setEMarriedTitleFa(teacher.getEMarried().getTitleFa());
        teacher.setEMilitaryTitleFa(teacher.getEMilitary().getTitleFa());
        teacher.setEGenderTitleFa(teacher.getEGender().getTitleFa());

        return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
	}

	@Transactional
	@Override
	public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {
		final Optional<Teacher> cById = teacherDAO.findById(id);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);

        updating.setEMarried(eMarriedConverter.convertToEntityAttribute(request.getEMarriedId()));
        updating.setEMilitary(eMilitaryConverter.convertToEntityAttribute(request.getEMilitaryId()));
        updating.setEGender(eGenderConverter.convertToEntityAttribute(request.getEGenderId()));

        updating.setEMarriedTitleFa(updating.getEMarried().getTitleFa());
        updating.setEMilitaryTitleFa(updating.getEMilitary().getTitleFa());
        updating.setEGenderTitleFa(updating.getEGender().getTitleFa());

        return modelMapper.map(teacherDAO.saveAndFlush(updating), TeacherDTO.Info.class);
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
        List<Category> gAllById = categoryDAO.findAllById(request.getIds());
        for (Category category : gAllById) {
            teacher.getCategories().add(category);
        }
    }
}
