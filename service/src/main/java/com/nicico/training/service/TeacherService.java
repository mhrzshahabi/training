package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

    private final CustomModelMapper modelMapper;
    private final TeacherDAO teacherDAO;
    private final CategoryDAO categoryDAO;
    private final PersonalInfoDAO personalInfoDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final ContactInfoDAO contactInfoDAO;
    private final AddressDAO addressDAO;


    private final EnumsConverter.EGenderConverter eGenderConverter = new EnumsConverter.EGenderConverter();
    private final EnumsConverter.EMarriedConverter eMarriedConverter = new EnumsConverter.EMarriedConverter();
    private final EnumsConverter.EMilitaryConverter eMilitaryConverter = new EnumsConverter.EMilitaryConverter();

    @Value("${nicico.dirs.upload-person-img}")
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
        ContactInfo contactInfo = null;
        AccountInfo accountInfo = null;
        Address homeAddress = null;
        Address workAddress = null;

        Long contactInfoId = null;
        Long accountInfoId = null;

        personalInfo = modelMapper.map(request.getPersonality(), PersonalInfo.class);
        List<PersonalInfo> personalInfos = personalInfoDAO.findByNationalCode(request.getPersonality().getNationalCode());

        teacher = modelMapper.map(request, Teacher.class);
        List<Teacher> teachers = teacherDAO.findByTeacherCode(teacher.getTeacherCode());

        if (teachers == null || teachers.size() == 0) {

            // person not exist
            if (personalInfos == null || personalInfos.size() == 0) {
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

                if (request.getPersonality().getMarriedId() != null) {
                    personalInfo.setMarried(eMarriedConverter.convertToEntityAttribute(request.getPersonality().getMarriedId()));
//                    personalInfo.setMarriedTitleFa(personalInfo.getMarried().getTitleFa());
                    personalInfo.setMarriedId(request.getPersonality().getMarriedId());
                }
                if (request.getPersonality().getMilitaryId() != null) {
                    personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(request.getPersonality().getMilitaryId()));
//                    personalInfo.setMilitaryTitleFa(personalInfo.getMilitary().getTitleFa());
                    personalInfo.setMilitaryId(request.getPersonality().getMilitaryId());
                }
                if (request.getPersonality().getGenderId() != null) {
                    personalInfo.setGender(eGenderConverter.convertToEntityAttribute(request.getPersonality().getGenderId()));
//                    personalInfo.setGenderTitleFa(personalInfo.getGender().getTitleFa());
                    personalInfo.setGenderId(request.getPersonality().getGenderId());
                }

                personalInfoDAO.saveAndFlush(personalInfo);
                teacher.setPersonalityId(personalInfo.getId());
                teacher.setPersonality(personalInfo);
            }
            //person exist
            else {

                final Optional<PersonalInfo> pById = personalInfoDAO.findById(personalInfos.get(0).getId());
                personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

                // InstituteAccount
                if (personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo() != null) {
                    final Optional<AccountInfo> cById = accountInfoDAO.findById(personalInfo.getAccountInfoId());
                    accountInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    AccountInfo updating = new AccountInfo();
                    modelMapper.map(accountInfo, updating);
                    modelMapper.map(request.getPersonality().getAccountInfo(), updating);
                    accountInfoDAO.saveAndFlush(updating);
                    accountInfo = updating;
                    accountInfoId = updating.getId();
                }

                if (personalInfo.getAccountInfoId() == null && request.getPersonality().getAccountInfo() != null) {
                    accountInfo = accountInfoDAO.saveAndFlush(modelMapper.map(request.getPersonality().getAccountInfo(), AccountInfo.class));
                    accountInfoId = accountInfo.getId();
                }

                if (personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo() == null) {
                    final Optional<AccountInfo> cById = accountInfoDAO.findById(personalInfo.getAccountInfoId());
                    accountInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    accountInfoDAO.delete(accountInfo);
                    accountInfo = null;
                    accountInfoId = null;
                }

                //Contact
                if (personalInfo.getContactInfoId() != null && request.getPersonality().getContactInfo() != null) {
                    Long homeAddressId = null;
                    Long workAddressId = null;

                    final Optional<ContactInfo> cById = contactInfoDAO.findById(personalInfo.getContactInfoId());
                    contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


                    if (contactInfo.getHomeAddressId() != null && request.getPersonality().getContactInfo().getHomeAddress() != null) {
                        final Optional<Address> aById = addressDAO.findById(contactInfo.getHomeAddressId());
                        homeAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        Address updating = new Address();
                        modelMapper.map(homeAddress, updating);
                        modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), updating);
                        addressDAO.saveAndFlush(updating);
                        homeAddress = updating;
                        homeAddressId = updating.getId();
                    }

                    if (contactInfo.getHomeAddressId() == null && request.getPersonality().getContactInfo().getHomeAddress() != null) {
                        homeAddress = addressDAO.saveAndFlush(modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), Address.class));
                        homeAddressId = homeAddress.getId();
                    }

                    if (contactInfo.getHomeAddressId() != null && request.getPersonality().getContactInfo().getHomeAddress() == null) {
                        final Optional<Address> aById = addressDAO.findById(contactInfo.getHomeAddressId());
                        homeAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        addressDAO.delete(homeAddress);
                        homeAddress = null;
                        homeAddressId = null;
                    }

                    if (contactInfo.getWorkAddressId() != null && request.getPersonality().getContactInfo().getWorkAddress() != null) {
                        final Optional<Address> aById = addressDAO.findById(contactInfo.getWorkAddressId());
                        workAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        Address updating = new Address();
                        modelMapper.map(workAddress, updating);
                        modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), updating);
                        addressDAO.saveAndFlush(updating);
                        workAddress = updating;
                        workAddressId = updating.getId();
                    }

                    if (contactInfo.getWorkAddressId() == null && request.getPersonality().getContactInfo().getWorkAddress() != null) {
                        workAddress = addressDAO.saveAndFlush(modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), Address.class));
                        workAddressId = workAddress.getId();
                    }

                    if (contactInfo.getWorkAddressId() != null && request.getPersonality().getContactInfo().getWorkAddress() == null) {
                        final Optional<Address> aById = addressDAO.findById(contactInfo.getWorkAddressId());
                        workAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        addressDAO.delete(workAddress);
                        workAddress = null;
                        workAddressId = null;
                    }

                    ContactInfo cupdating = new ContactInfo();
                    modelMapper.map(contactInfo, cupdating);
                    modelMapper.map(request.getPersonality().getContactInfo(), cupdating);
                    cupdating.setHomeAddressId(homeAddressId);
                    cupdating.setHomeAddress(homeAddress);
                    cupdating.setWorkAddressId(workAddressId);
                    cupdating.setWorkAddress(workAddress);
                    contactInfoDAO.saveAndFlush(cupdating);
                    contactInfo = cupdating;
                    contactInfoId = cupdating.getId();
                }

                if (personalInfo.getContactInfoId() == null && request.getPersonality().getContactInfo() != null) {
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

                    contactInfo = contactInfoDAO.saveAndFlush(contactInfo);
                    contactInfoId = contactInfo.getId();
                }

                if (personalInfo.getContactInfoId() != null && request.getPersonality().getContactInfo() == null) {
                    final Optional<ContactInfo> aById = contactInfoDAO.findById(personalInfo.getContactInfoId());
                    contactInfo = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (contactInfo.getHomeAddress() != null) {
                        final Optional<Address> tById = addressDAO.findById(contactInfo.getHomeAddressId());
                        homeAddress = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        contactInfo.setHomeAddress(null);
                        contactInfo.setHomeAddressId(null);
                        addressDAO.delete(homeAddress);
                    }
                    if (contactInfo.getWorkAddress() != null) {
                        final Optional<Address> tById = addressDAO.findById(contactInfo.getWorkAddressId());
                        workAddress = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        contactInfo.setWorkAddress(null);
                        contactInfo.setWorkAddressId(null);
                        addressDAO.delete(workAddress);

                    }
                    contactInfoDAO.delete(contactInfo);
                    contactInfo = null;
                    contactInfoId = null;
                }

                if (request.getPersonality().getMarriedId() != null) {
                    personalInfo.setMarried(eMarriedConverter.convertToEntityAttribute(request.getPersonality().getMarriedId()));
//                    personalInfo.setMarriedTitleFa(personalInfo.getMarried().getTitleFa());
                    personalInfo.setMarriedId(request.getPersonality().getMarriedId());
                }
                if (request.getPersonality().getMilitaryId() != null) {
                    personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(request.getPersonality().getMilitaryId()));
//                    personalInfo.setMilitaryTitleFa(personalInfo.getMilitary().getTitleFa());
                    personalInfo.setMilitaryId(request.getPersonality().getMilitaryId());
                }
                if (request.getPersonality().getGenderId() != null) {
                    personalInfo.setGender(eGenderConverter.convertToEntityAttribute(request.getPersonality().getGenderId()));
//                    personalInfo.setGenderTitleFa(personalInfo.getGender().getTitleFa());
                    personalInfo.setGenderId(request.getPersonality().getGenderId());
                }

                PersonalInfo pupdating = new PersonalInfo();
                modelMapper.map(personalInfo, pupdating);
                modelMapper.map(request.getPersonality(), pupdating);
                pupdating.setAccountInfo(accountInfo);
                pupdating.setAccountInfoId(accountInfoId);
                pupdating.setContactInfo(contactInfo);
                pupdating.setContactInfoId(contactInfoId);
                personalInfoDAO.saveAndFlush(pupdating);
                teacher.setPersonalityId(pupdating.getId());
                teacher.setPersonality(pupdating);
            }
            return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
        } else
            return null;

    }


    @Transactional
    @Override
    public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {
        Teacher teacher;
        PersonalInfo personalInfo;
        ContactInfo contactInfo = null;
        AccountInfo accountInfo = null;
        Address homeAddress = null;
        Address workAddress = null;

        Long contactInfoId = null;
        Long accountInfoId = null;

        List<PersonalInfo> personalInfos = personalInfoDAO.findByNationalCode(request.getPersonality().getNationalCode());
        final Optional<PersonalInfo> pById = personalInfoDAO.findById(personalInfos.get(0).getId());
        personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        // InstituteAccount
        if (personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo() != null) {
            final Optional<AccountInfo> cById = accountInfoDAO.findById(personalInfo.getAccountInfoId());
            accountInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            AccountInfo updating = new AccountInfo();
            modelMapper.map(accountInfo, updating);
            modelMapper.map(request.getPersonality().getAccountInfo(), updating);
            accountInfoDAO.saveAndFlush(updating);
            accountInfo = updating;
            accountInfoId = updating.getId();
        }

        if (personalInfo.getAccountInfoId() == null && request.getPersonality().getAccountInfo() != null) {
            accountInfo = accountInfoDAO.saveAndFlush(modelMapper.map(request.getPersonality().getAccountInfo(), AccountInfo.class));
            accountInfoId = accountInfo.getId();
        }

        if (personalInfo.getAccountInfoId() != null && request.getPersonality().getAccountInfo() == null) {
            final Optional<AccountInfo> cById = accountInfoDAO.findById(personalInfo.getAccountInfoId());
            accountInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            accountInfoDAO.delete(accountInfo);
            accountInfo = null;
            accountInfoId = null;
        }

        //Contact
        if (personalInfo.getContactInfoId() != null && request.getPersonality().getContactInfo() != null) {
            Long homeAddressId = null;
            Long workAddressId = null;

            final Optional<ContactInfo> cById = contactInfoDAO.findById(personalInfo.getContactInfoId());
            contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


            if (contactInfo.getHomeAddressId() != null && request.getPersonality().getContactInfo().getHomeAddress() != null) {
                final Optional<Address> aById = addressDAO.findById(contactInfo.getHomeAddressId());
                homeAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                Address updating = new Address();
                modelMapper.map(homeAddress, updating);
                modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), updating);
                addressDAO.saveAndFlush(updating);
                homeAddress = updating;
                homeAddressId = updating.getId();
            }

            if (contactInfo.getHomeAddressId() == null && request.getPersonality().getContactInfo().getHomeAddress() != null) {
                homeAddress = addressDAO.saveAndFlush(modelMapper.map(request.getPersonality().getContactInfo().getHomeAddress(), Address.class));
                homeAddressId = homeAddress.getId();
            }

            if (contactInfo.getHomeAddressId() != null && request.getPersonality().getContactInfo().getHomeAddress() == null) {
                final Optional<Address> aById = addressDAO.findById(contactInfo.getHomeAddressId());
                homeAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                addressDAO.delete(homeAddress);
                homeAddress = null;
                homeAddressId = null;
            }

            if (contactInfo.getWorkAddressId() != null && request.getPersonality().getContactInfo().getWorkAddress() != null) {
                final Optional<Address> aById = addressDAO.findById(contactInfo.getWorkAddressId());
                workAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                Address updating = new Address();
                modelMapper.map(workAddress, updating);
                modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), updating);
                addressDAO.saveAndFlush(updating);
                workAddress = updating;
                workAddressId = updating.getId();
            }

            if (contactInfo.getWorkAddressId() == null && request.getPersonality().getContactInfo().getWorkAddress() != null) {
                workAddress = addressDAO.saveAndFlush(modelMapper.map(request.getPersonality().getContactInfo().getWorkAddress(), Address.class));
                workAddressId = workAddress.getId();
            }

            if (contactInfo.getWorkAddressId() != null && request.getPersonality().getContactInfo().getWorkAddress() == null) {
                final Optional<Address> aById = addressDAO.findById(contactInfo.getWorkAddressId());
                workAddress = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                addressDAO.delete(workAddress);
                workAddress = null;
                workAddressId = null;
            }

            ContactInfo cupdating = new ContactInfo();
            modelMapper.map(contactInfo, cupdating);
            modelMapper.map(request.getPersonality().getContactInfo(), cupdating);
            cupdating.setHomeAddressId(homeAddressId);
            cupdating.setHomeAddress(homeAddress);
            cupdating.setWorkAddressId(workAddressId);
            cupdating.setWorkAddress(workAddress);
            contactInfoDAO.saveAndFlush(cupdating);
            contactInfo = cupdating;
            contactInfoId = cupdating.getId();
        }

        if (personalInfo.getContactInfoId() == null && request.getPersonality().getContactInfo() != null) {
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

            contactInfo = contactInfoDAO.saveAndFlush(contactInfo);
            contactInfoId = contactInfo.getId();
        }

        if (personalInfo.getContactInfoId() != null && request.getPersonality().getContactInfo() == null) {
            final Optional<ContactInfo> aById = contactInfoDAO.findById(personalInfo.getContactInfoId());
            contactInfo = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            if (contactInfo.getHomeAddress() != null) {
                final Optional<Address> tById = addressDAO.findById(contactInfo.getHomeAddressId());
                homeAddress = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                contactInfo.setHomeAddress(null);
                contactInfo.setHomeAddressId(null);
                addressDAO.delete(homeAddress);
            }
            if (contactInfo.getWorkAddress() != null) {
                final Optional<Address> tById = addressDAO.findById(contactInfo.getWorkAddressId());
                workAddress = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                contactInfo.setWorkAddress(null);
                contactInfo.setWorkAddressId(null);
                addressDAO.delete(workAddress);

            }
            contactInfoDAO.delete(contactInfo);
            contactInfo = null;
            contactInfoId = null;
        }

        if (request.getPersonality().getMarriedId() != null) {
            personalInfo.setMarried(eMarriedConverter.convertToEntityAttribute(request.getPersonality().getMarriedId()));
//            personalInfo.setMarriedTitleFa(personalInfo.getMarried().getTitleFa());
            personalInfo.setMarriedId(request.getPersonality().getMarriedId());
        }
        if (request.getPersonality().getMilitaryId() != null) {
            personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(request.getPersonality().getMilitaryId()));
//            personalInfo.setMilitaryTitleFa(personalInfo.getMilitary().getTitleFa());
            personalInfo.setMilitaryId(request.getPersonality().getMilitaryId());
        }
        if (request.getPersonality().getGenderId() != null) {
            personalInfo.setGender(eGenderConverter.convertToEntityAttribute(request.getPersonality().getGenderId()));
//            personalInfo.setGenderTitleFa(personalInfo.getGender().getTitleFa());
            personalInfo.setGenderId(request.getPersonality().getGenderId());
        }

        PersonalInfo pupdating = new PersonalInfo();
        modelMapper.map(personalInfo, pupdating);
        modelMapper.map(request.getPersonality(), pupdating);
        pupdating.setAccountInfo(accountInfo);
        pupdating.setAccountInfoId(accountInfoId);
        pupdating.setContactInfo(contactInfo);
        pupdating.setContactInfoId(contactInfoId);
        personalInfoDAO.saveAndFlush(pupdating);


        final Optional<Teacher> cById = teacherDAO.findById(id);
        teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        teacher.setPersonalityId(pupdating.getId());
        teacher.setPersonality(pupdating);
        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);
        return save(updating);
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

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearch(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.TeacherFullNameTuple.class));
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
        if (currents != null) {
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
        List<Long> categories = new ArrayList<>();
        for (Category current : currents) {
            categories.add(current.getId());
        }
        return categories;
    }

}
