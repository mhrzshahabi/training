package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.hrm.HrmFeignClient;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ContactInfoService implements IContactInfoService {
    private final ModelMapper modelMapper;
    private final ContactInfoDAO contactInfoDAO;
    private final AddressService addressService;
    private final HrmFeignClient hrmClient;
    private final PersonnelDAO personnelDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;
    private final StudentDAO studentDAO;
    private final MessageSource messageSource;

    @Transactional(readOnly = true)
    @Override
    public ContactInfoDTO.Info get(Long id) {
        final Optional<ContactInfo> gById = contactInfoDAO.findById(id);
        final ContactInfo contactInfo = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(contactInfo, ContactInfoDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<ContactInfoDTO.Info> list() {
        final List<ContactInfo> gAll = contactInfoDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<ContactInfoDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info create(ContactInfoDTO.Create request) {

        final ContactInfo contactInfo = modelMapper.map(request, ContactInfo.class);
        try {
            return modelMapper.map(contactInfoDAO.saveAndFlush(contactInfo), ContactInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }


    @Transactional
    @Override
    public ContactInfoDTO.Info createNewFor(Long id, String type) {
        ContactInfo contactInfo = contactInfoDAO.saveAndFlush(new ContactInfo());
        switch (type) {
            case "Personnel":
                Personnel personnel = personnelDAO.findById(id).get();
                personnel.setContactInfo(contactInfo);
                personnelDAO.saveAndFlush(personnel);
                break;
            case "RegisteredPersonnel":
                PersonnelRegistered personnelRegistered = personnelRegisteredDAO.getById(id);
                personnelRegistered.setContactInfo(contactInfo);
                personnelRegisteredDAO.saveAndFlush(personnelRegistered);
                break;
            case "Student":
                Student student = studentDAO.getById(id);
                student.setContactInfo(contactInfo);
                studentDAO.saveAndFlush(student);
                break;
            default:
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
        return modelMapper.map(contactInfo, ContactInfoDTO.Info.class);
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request) {

        Map<String, Object> map = new HashMap<>();
        if (request.getMobile() != null && !request.getMobile().trim().isEmpty())
            map.putAll(nationalCodeOfMobile(request.getMobile()));
        if (request.getMobile2() != null && !request.getMobile2().trim().isEmpty())
            map.putAll(nationalCodeOfMobile(request.getMobile2()));
        Object record = getCorrespondingRecordOfContactInfo(id, request.getParentId());
        String msg = "";
        final Locale locale = LocaleContextHolder.getLocale();
        for (String nc : map.keySet()) {
            Object already = map.get(nc);
            String alreadyNc = "";
            String recordNc = "";
            if (already instanceof Student) {
                alreadyNc = ((Student) already).getNationalCode();
                msg = messageSource.getMessage("msg.duplicate.mobile.number.student", new Object[]{alreadyNc}, locale);
            } else if (already instanceof Personnel) {
                alreadyNc = ((Personnel) already).getNationalCode();
                msg = messageSource.getMessage("msg.duplicate.mobile.number.Personnel", new Object[]{alreadyNc}, locale);
            } else if (already instanceof PersonnelRegistered) {
                alreadyNc = ((PersonnelRegistered) already).getNationalCode();
                msg = messageSource.getMessage("msg.duplicate.mobile.number.RegisteredPersonnel", new Object[]{alreadyNc}, locale);
            }
            if (record instanceof Student) {
                recordNc = ((Student) record).getNationalCode();
            } else if (record instanceof Personnel) {
                recordNc = ((Personnel) record).getNationalCode();
            } else if (record instanceof PersonnelRegistered) {
                recordNc = ((PersonnelRegistered) record).getNationalCode();
            }
            if ((alreadyNc == null && recordNc != null) || !Objects.equals(alreadyNc, recordNc)) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateMobile, msg, msg);
            }
            if (recordNc==null){
                msg = messageSource.getMessage("msg.duplicate.mobile.number.national.code.RegisteredPersonnel", new Object[]{alreadyNc}, locale);
                throw new TrainingException(TrainingException.ErrorType.DuplicateMobile, msg, msg);
            }
        }
        final Optional<ContactInfo> cById = contactInfoDAO.findById(id);
        ContactInfo contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        ContactInfo cUpdating = new ContactInfo();
        modelMapper.map(contactInfo, cUpdating);
        modelMapper.map(request, cUpdating);

        try {
            ContactInfo contactInfo1=contactInfoDAO.saveAndFlush(cUpdating);
            boolean savedToAllRepos= updateAllRepositoriesWithThisContactInfo(record,contactInfo1);
            if (savedToAllRepos)
            return modelMapper.map(contactInfo1, ContactInfoDTO.Info.class);
            else{
                msg = messageSource.getMessage("msg.mobile.not.saved.in.all.repositories", null, locale);
                throw new TrainingException(TrainingException.ErrorType.DuplicateMobile, msg, msg);

            }

        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Override
    @Transactional
    public boolean updateAllRepositoriesWithThisContactInfo(Object record, ContactInfo contactInfo1) {
        String recordNc = "";
            if (record instanceof Student) {
                recordNc = ((Student) record).getNationalCode();
            } else if (record instanceof Personnel) {
                recordNc = ((Personnel) record).getNationalCode();
            } else if (record instanceof PersonnelRegistered) {
                recordNc = ((PersonnelRegistered) record).getNationalCode();
            }

//
        //        update all student
        List<Student> studentList = studentDAO.findByNationalCode(recordNc);
            if (!studentList.isEmpty()){
                for (Student student:studentList){
                    student.setContactInfo(contactInfo1);
                    student.setContactInfoId(contactInfo1.getId());
                    studentDAO.saveAndFlush(student);
                }
            }

//      update all    personnelRegistered
        List<PersonnelRegistered> personnelRegisteredList = personnelRegisteredDAO.findAllByNationalCodeOrderByIdDesc(recordNc);
        if (!personnelRegisteredList.isEmpty()){
            for (PersonnelRegistered personnelRegistered:personnelRegisteredList){
                personnelRegistered.setContactInfo(contactInfo1);
                personnelRegistered.setContactInfoId(contactInfo1.getId());
                personnelRegisteredDAO.saveAndFlush(personnelRegistered);
            }
        }



//           update all     personnel
        List<Personnel> personnelList = personnelDAO.findAllByNationalCodeOrderByIdDesc(recordNc);
        if (!personnelList.isEmpty()){
            for (Personnel personnel:personnelList){
                personnel.setContactInfo(contactInfo1);
                personnel.setContactInfoId(contactInfo1.getId());
                personnelDAO.saveAndFlush(personnel);
            }
        }
        return true;
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            contactInfoDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(ContactInfoDTO.Delete request) {
        final List<ContactInfo> gAllById = contactInfoDAO.findAllById(request.getIds());
        contactInfoDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ContactInfoDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(contactInfoDAO, request, contactInfo -> modelMapper.map(contactInfo, ContactInfoDTO.Info.class));
    }


    @Transactional
    @Override
    public void modify(ContactInfoDTO.CreateOrUpdate request, ContactInfo contactInfo) {
        if (request.getHomeAddress() != null && request.getHomeAddress().getPostalCode() != null) {
            Address address = addressService.getByPostalCode(request.getHomeAddress().getPostalCode());
            if (address != null) {
                request.getHomeAddress().setId(address.getId());
                request.setHomeAddressId(address.getId());
                if (contactInfo != null)
                    contactInfo.setHomeAddress(address);
                else {
                    modelMapper.map(request.getHomeAddress(), address);
                    request.setHomeAddress(modelMapper.map(address, AddressDTO.CreateOrUpdate.class));
                }
            }
        }
        if (request.getWorkAddress() != null && request.getWorkAddress().getPostalCode() != null) {
            Address address = addressService.getByPostalCode(request.getWorkAddress().getPostalCode());
            if (address != null) {
                request.getWorkAddress().setId(address.getId());
                request.setWorkAddressId(address.getId());
                if (contactInfo != null)
                    contactInfo.setWorkAddress(address);
                else {
                    modelMapper.map(request.getWorkAddress(), address);
                    request.setWorkAddress(modelMapper.map(address, AddressDTO.CreateOrUpdate.class));
                }
            }
        }
    }

    @Transactional
    @Override
    public ContactInfo fetchAndUpdateLastHrMobile(Long id, String type, String token) {
        Map[] maps = getOrCreateContactInfos(Collections.singletonList(id), type);
        Map<String, ContactInfo> fromHr = updateContactInfosWithHR(Collections.singletonMap(((String) maps[1].get(id)), ((ContactInfo) maps[0].get(id))), token);
        ContactInfo hr = fromHr.get(maps[1].get(id));
        if (hr != null)
            return hr;
        else
            return (ContactInfo) maps[0].values().iterator().next();
    }


    @Transactional
    @Override
    public Map<Long, ContactInfo> fetchAndUpdateLastHrMobile(List<Long> ids, String type, String token) {
        Map[] maps = getOrCreateContactInfos(ids, type);
        Map<String, ContactInfo> ncToContact = new HashMap<>();
        for (Long id : ids) {
            ncToContact.put(((String) maps[1].get(id)), ((ContactInfo) maps[0].get(id)));
        }
        Map<String, ContactInfo> fromHr = updateContactInfosWithHR(ncToContact, token);
        Map<Long, ContactInfo> result = new HashMap<>();
        for (Long id : ids) {
            ContactInfo hr = fromHr.get(maps[1].get(id));
            if (hr != null)
                result.put(id, hr);
            else
                result.put(id, (ContactInfo) maps[0].get(id));
        }
        return result;
    }

    private Map[] getOrCreateContactInfos(List<Long> ids, String type) {
        Map<Long, ContactInfo> contactInfos = new HashMap<>();
        Map<Long, String> idToNationalCode = new HashMap<>();
        Map[] maps = new Map[]{contactInfos, idToNationalCode};
        switch (type) {
            case "Personnel":
                for (Long id : ids) {
                    Personnel personnel = personnelDAO.findById(id).get();
                    ContactInfo contactInfo = personnel.getContactInfo();
                    if (personnel.getContactInfoId() == null) {
                        contactInfo = new ContactInfo();
                        contactInfoDAO.save(contactInfo);
                        personnel.setContactInfo(contactInfo);
                        personnelDAO.saveAndFlush(personnel);
                    }
                    String nationalCode = personnel.getNationalCode();
                    contactInfos.put(id, contactInfo);
                    idToNationalCode.put(id, nationalCode);
                }
                break;
            case "RegisteredPersonnel":
                for (Long id : ids) {
                    PersonnelRegistered personnelRegistered = personnelRegisteredDAO.getById(id);
                    ContactInfo contactInfo = personnelRegistered.getContactInfo();
                    if (personnelRegistered.getContactInfoId() == null) {
                        contactInfo = new ContactInfo();
                        contactInfoDAO.save(contactInfo);
                        personnelRegistered.setContactInfo(contactInfo);
                        personnelRegisteredDAO.saveAndFlush(personnelRegistered);
                    }
                    String nationalCode = personnelRegistered.getNationalCode();
                    contactInfos.put(id, contactInfo);
                    idToNationalCode.put(id, nationalCode);
                }
                break;
            case "Student":
                for (Long id : ids) {
                    Student student = studentDAO.findById(id).get();
                    ContactInfo contactInfo = student.getContactInfo();
                    if (contactInfo == null) {
                        contactInfo = new ContactInfo();
                        contactInfoDAO.save(contactInfo);
                        student.setContactInfo(contactInfo);
                        studentDAO.saveAndFlush(student);
                    }
                    String nationalCode = student.getNationalCode();
                    contactInfos.put(id, contactInfo);
                    idToNationalCode.put(id, nationalCode);
                }
                break;
            default:
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
        return maps;
    }

    private Map<String, ContactInfo> updateContactInfosWithHR(Map<String, ContactInfo> contactInfos, String token) {
        Map<String, ContactInfo> map = new HashMap<>();
        if (contactInfos.size() == 0)
            return map;
        long now = new Date().getTime();
        ContactInfo anyContact = contactInfos.values().stream().findAny().get();
        long lastModified = anyContact.getLastModifiedDate() == null ? 0 : anyContact.getLastModifiedDate().getTime();
        if ((now - lastModified) / 1000 / 60 > 5) {
            List<String> nationalCodes = contactInfos.keySet().stream().filter(Objects::nonNull).collect(Collectors.toList());
            if (!nationalCodes.isEmpty())
                try {
                    HrmMobileListDTO.Response mobilesByNationalCodes = hrmClient.getMobilesByNationalCodes(new HrmMobileListDTO.Request().setNationalCodes(nationalCodes), token);
                    Map<String, String> result = mobilesByNationalCodes.getResult();
                    for (String nc : result.keySet()) {
                        final Optional<ContactInfo> cById = contactInfoDAO.findById(contactInfos.get(nc).getId());
                        if (cById.isPresent()) {
                            ContactInfo contact = cById.get();
                            contact.setHrMobile(result.get(nc));
                            contactInfoDAO.saveAndFlush(contact);
                            map.put(nc, contact);
                        }
                    }
                } catch (Exception ex) {
                    System.err.println("HRM API Error");
                }
        }
        return map;
    }

    @Override
    public Map<String, Object> nationalCodeOfMobile(String mobile) {
        Map<String, Object> result = new HashMap<>();
        List<ContactInfo> contactInfos = new ArrayList<>();
        if (mobile.startsWith("0")) {
            contactInfos.addAll(contactInfoDAO.findAllByMobiles(mobile));
            contactInfos.addAll(contactInfoDAO.findAllByMobiles(mobile.substring(1)));
        } else {
            contactInfos.addAll(contactInfoDAO.findAllByMobiles(mobile));
            contactInfos.addAll(contactInfoDAO.findAllByMobiles("0" + mobile));
        }
        if (!contactInfos.isEmpty()) {
            List<Student> students = studentDAO.findAllByContactInfoIds(contactInfos.stream().map(ContactInfo::getId).collect(Collectors.toList()));
            students.forEach(student -> result.put(student.getNationalCode(), student));
            if (!students.isEmpty())
                return result;
            List<Personnel> personnels = personnelDAO.findAllByContactInfoIds(contactInfos.stream().map(ContactInfo::getId).collect(Collectors.toList()));
            personnels.forEach(personnel -> result.put(personnel.getNationalCode(), personnel));
            if (!personnels.isEmpty())
                return result;
            List<PersonnelRegistered> personnelRegistereds = personnelRegisteredDAO.findAllByContactInfoIds(contactInfos.stream().map(ContactInfo::getId).collect(Collectors.toList()));
            personnelRegistereds.forEach(personnelRegistered -> result.put(personnelRegistered.getNationalCode(), personnelRegistered));
        }
        return result;
    }

    @Override
    public Object getCorrespondingRecordOfContactInfo(Long id, Long parentId) {
        Optional optional = personnelDAO.findByContactInfoId(id);
        if (optional.isPresent())
            return optional.get();
        optional = personnelRegisteredDAO.findByContactInfoId(id);
        if (optional.isPresent())
            return optional.get();
        optional = studentDAO.findByContactInfoId(id, parentId);
        if (optional.isPresent())
            return optional.get();
        return null;
    }


}
