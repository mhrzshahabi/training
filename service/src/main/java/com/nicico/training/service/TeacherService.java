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
	private final PersonalInfoDAO personalInfoDAO;
	private final ContactInfoDAO contactInfoDAO;
	private final AccountInfoDAO accountInfoDAO;
	private final AddressDAO addressDAO;

	private final EnumsConverter.EGenderConverter eGenderConverter = new EnumsConverter.EGenderConverter();
    private final EnumsConverter.EMarriedConverter eMarriedConverter = new EnumsConverter.EMarriedConverter();
    private final EnumsConverter.EMilitaryConverter eMilitaryConverter = new EnumsConverter.EMilitaryConverter();

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
		ContactInfo contactInfo;
		AccountInfo accountInfo;
		Address homeAddress;
		Address workAddress;

		teacher = modelMapper.map(request, Teacher.class);
		personalInfo = modelMapper.map(request.getPersonality(),PersonalInfo.class);

		List<PersonalInfo> personalInfos = personalInfoDAO.findByNationalCode(request.getPersonality().getNationalCode());
		List<Teacher> teachers = teacherDAO.findByTeacherCode(teacher.getTeacherCode());

		if(teachers==null || teachers.size()==0) {

			if (request.getPersonality().getAccountInfo() != null) {
				accountInfo = modelMapper.map(request.getPersonality().getAccountInfo(), AccountInfo.class);
				accountInfoDAO.saveAndFlush(accountInfo);
				personalInfo.setAccountInfo(accountInfo);
				personalInfo.setAccountInfoId(accountInfo.getId());
			}

			if (request.getPersonality().getContactInfo() != null) {
				contactInfo = modelMapper.map(request.getPersonality().getContactInfo(), ContactInfo.class);
				if (request.getPersonality().getContactInfo().getHomeAddress() != null) {
					homeAddress = modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), Address.class);
					addressDAO.saveAndFlush(homeAddress);
					contactInfo.setHomeAddress(homeAddress);
					contactInfo.setHomeAddressId(homeAddress.getId());
				}
				if (request.getPersonality().getContactInfo().getWorkAddress() != null) {
					workAddress = modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), Address.class);
					addressDAO.saveAndFlush(workAddress);
					contactInfo.setWorkAddress(workAddress);
					contactInfo.setWorkAddressId(workAddress.getId());
				}
				contactInfoDAO.saveAndFlush(contactInfo);
				personalInfo.setContactInfo(contactInfo);
				personalInfo.setContactInfoId(contactInfo.getId());
			}

			if(request.getPersonality().getEMarriedId() != null) {
				personalInfo.setEMarried(eMarriedConverter.convertToEntityAttribute(request.getPersonality().getEMarriedId()));
				personalInfo.setEMarriedTitleFa(personalInfo.getEMarried().getTitleFa());
			}
			if(request.getPersonality().getEMilitaryId() != null) {
				 personalInfo.setEMilitary(eMilitaryConverter.convertToEntityAttribute(request.getPersonality().getEMilitaryId()));
				 personalInfo.setEMilitaryTitleFa(personalInfo.getEMilitary().getTitleFa());
			}
			if(request.getPersonality().getEGenderId() != null) {
				personalInfo.setEGender(eGenderConverter.convertToEntityAttribute(request.getPersonality().getEGenderId()));
				personalInfo.setEGenderTitleFa(personalInfo.getEGender().getTitleFa());
			}

			personalInfoDAO.saveAndFlush(personalInfo);
			teacher.setPersonality(personalInfo);
			teacher.setPersonalityId(personalInfo.getId());
			return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
		}
		else
			return null;
	}


	@Transactional
	@Override
	public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {
		Teacher teacher = null;
		PersonalInfo personalInfo = null;
		ContactInfo contactInfo = null;
		AccountInfo accountInfo = null;
		Address homeAddress = null;
		Address workAddress = null;

		Long teacherId = null;
		Long personalInfoId = null;
		Long contactInfoId = null;
		Long accountInfoId = null;
		Long homeAddressId = null;
		Long workAddressId = null;

		teacherId = id;
		final Optional<Teacher> tById = teacherDAO.findById(teacherId);
        teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

		personalInfoId = teacher.getPersonalityId();
        final Optional<PersonalInfo> pById = personalInfoDAO.findById(personalInfoId);
        personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

		/////////////////////////////////////////////////////Account////////////////////////////////////////////////////
        if(personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo()!=null) {
 			final Optional<AccountInfo> aById = accountInfoDAO.findById(personalInfo.getAccountInfoId());
			accountInfo = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
			AccountInfo aupdating = new AccountInfo();
			modelMapper.map(accountInfo,aupdating);
			modelMapper.map((new ModelMapper()).map(request.getPersonality().getAccountInfo(), AccountInfoDTO.Update.class),aupdating);
			accountInfoDAO.saveAndFlush(aupdating);
			accountInfo = aupdating;
			accountInfoId = aupdating.getId();
		}

		if(personalInfo.getAccountInfoId() == null && request.getPersonality().getAccountInfo()!=null) {
        		accountInfo = modelMapper.map(request.getPersonality().getAccountInfo(), AccountInfo.class);
				accountInfoDAO.saveAndFlush(accountInfo);
				accountInfoId = accountInfo.getId();
		}

		if(personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo()==null) {
			accountInfoId = personalInfo.getAccountInfoId();
        	final Optional<AccountInfo> aById = accountInfoDAO.findById(accountInfoId);
			accountInfoDAO.deleteById(accountInfoId);
			accountInfo = null;
			accountInfoId = null;
		}
		////////////////////////////////////HomeAddress/////////////////////////////////////////////////////////////////////
		   if(personalInfo.getContactInfo() != null &&
		   		personalInfo.getContactInfo().getHomeAddress() != null &&
		   		request.getPersonality().getContactInfo() != null &&
		   		request.getPersonality().getContactInfo().getHomeAddress()!=null) {
 			final Optional<Address> haById = addressDAO.findById(personalInfo.getContactInfo().getHomeAddressId());
			homeAddress = haById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
			Address haupdating = new Address();
			modelMapper.map(homeAddress,haupdating);
			modelMapper.map((new ModelMapper()).map(request.getPersonality().getContactInfo().getHomeAddress(), AddressDTO.Update.class),haupdating);
			addressDAO.saveAndFlush(haupdating);
			homeAddress = haupdating;
			homeAddressId = haupdating.getId();
		}

		if(personalInfo.getContactInfo().getHomeAddress() == null &&
		 request.getPersonality().getContactInfo() != null &&
		 request.getPersonality().getContactInfo().getHomeAddress() != null) {
        		homeAddress = modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), Address.class);
				addressDAO.saveAndFlush(homeAddress);
				homeAddressId = homeAddress.getId();
		}

		if(personalInfo.getContactInfo() != null &&
			personalInfo.getContactInfo().getHomeAddress() != null &&
			request.getPersonality().getContactInfo().getHomeAddress() == null) {
			homeAddressId = personalInfo.getContactInfo().getHomeAddressId();
			addressDAO.deleteById(homeAddressId);
			homeAddress = null;
			homeAddressId = null;
		}
			////////////////////////////////////WorkAddress/////////////////////////////////////////////////////////////////////
	if(personalInfo.getContactInfo().getWorkAddress() != null && request.getPersonality().getContactInfo().getWorkAddress()!=null) {
 			final Optional<Address> haById = addressDAO.findById(personalInfo.getContactInfo().getWorkAddressId());
			workAddress = haById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
			Address waupdating = new Address();
			modelMapper.map(workAddress,waupdating);
			modelMapper.map((new ModelMapper()).map(request.getPersonality().getContactInfo().getWorkAddress(), AddressDTO.Update.class),waupdating);
			addressDAO.saveAndFlush(waupdating);
			workAddress = waupdating;
			workAddressId = waupdating.getId();
		}

		if(personalInfo.getContactInfo().getWorkAddress() == null && request.getPersonality().getContactInfo().getWorkAddress() != null) {
        		workAddress = modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), Address.class);
				addressDAO.saveAndFlush(workAddress);
				workAddressId = workAddress.getId();
		}

		if(personalInfo.getContactInfo().getWorkAddress() != null && request.getPersonality().getContactInfo().getWorkAddress() == null) {
			workAddressId = personalInfo.getContactInfo().getWorkAddressId();
			addressDAO.deleteById(workAddressId);
			workAddress = null;
			workAddressId = null;
		}
		/////////////////////////////////////////////////////////Contact////////////////////////////////////////////////
		if(personalInfo.getContactInfo() != null && request.getPersonality().getContactInfo()!=null) {
 			final Optional<ContactInfo> cById = contactInfoDAO.findById(personalInfo.getContactInfoId());
			contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
			ContactInfo cupdating = new ContactInfo();
			modelMapper.map(contactInfo,cupdating);
			modelMapper.map((new ModelMapper()).map(request.getPersonality().getContactInfo(), ContactInfoDTO.Update.class),cupdating);

			cupdating.setWorkAddressId(workAddressId);
			cupdating.setWorkAddress(workAddress);
			cupdating.setHomeAddressId(homeAddressId);
			cupdating.setHomeAddress(homeAddress);

			contactInfoDAO.saveAndFlush(cupdating);
			contactInfo = cupdating;
			contactInfoId = contactInfo.getId();
		}

		if(personalInfo.getContactInfoId() == null && request.getPersonality().getContactInfo()!=null) {
        		contactInfo = modelMapper.map(request.getPersonality().getContactInfo(), ContactInfo.class);

        		contactInfo.setWorkAddressId(workAddressId);
				contactInfo.setWorkAddress(workAddress);
				contactInfo.setHomeAddressId(homeAddressId);
				contactInfo.setHomeAddress(homeAddress);

				contactInfoDAO.saveAndFlush(contactInfo);
				contactInfoId = contactInfo.getId();
		}

		if(personalInfo.getContactInfoId() != null && request.getPersonality().getContactInfo()==null) {
			contactInfoId = personalInfo.getContactInfoId();
        	final Optional<ContactInfo> cById = contactInfoDAO.findById(contactInfoId);
			contactInfoDAO.deleteById(contactInfoId);
			contactInfo = null;
			contactInfoId = null;
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        PersonalInfo pupdating = new PersonalInfo();
        modelMapper.map(personalInfo,pupdating);
        modelMapper.map((new ModelMapper()).map(request.getPersonality(), PersonalInfoDTO.Update.class),pupdating);
        pupdating.setAccountInfo(accountInfo);
        pupdating.setAccountInfoId(accountInfoId);
        pupdating.setContactInfo(contactInfo);
        pupdating.setContactInfoId(contactInfoId);
        personalInfoDAO.saveAndFlush(pupdating);

        Teacher tupdating = new Teacher();
        modelMapper.map(teacher, tupdating);
        modelMapper.map(request, tupdating);
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
