//
//  AddChallengeView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

enum ChallengeEditorMode {
    case add
    case edit
}

struct AddChallengeView: View {
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: ChallengeViewModel
    @State private var selectedCategory: Int = -1
    @State private var date: Date = Date()
    /// 선택한 날짜를 저장하는 변수
    @State private var didSelectStartDate: Bool = false
    @State private var didSelectEndDate: Bool = false

    /// 카테고리 바텀시트를 보여주도록 하는 상태변수
    @State private var isActiveCategory: Bool = false
    /// datepicker을 보여주도록 하는 변수
    @State private var isActivePicker: Bool = false
    /// 시작일, 종료일 중 어느걸 선택하는지 구분하는 상태
    @State private var isPickerStartData = true
    /// 사용자가 데이터를 받아와서 저장할 배열
    let mode: ChallengeEditorMode
    let editingItem: ListItemModel?
    

    var body: some View {
        let navigationTitle = mode == .add ? "도전 일기 추가하기" : "도전 일기 수정하기"

        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 40)
                titleComponent()
                
                Spacer().frame(height: 33)
                
                categoryComponent()
                
                Spacer().frame(height: 25)
                
                setDateComponent()
                
                Spacer().frame(height: 33)
                
                memoComponent()
                
                Spacer()
                
                
                CustomBottomBtn(action: {
                    viewModel.formValid { success in
                        if success {
                            viewModel.saveChallenge(context: viewContext, mode: mode)

                            switch mode {
                            case .add:
                                self.presentationMode.wrappedValue.dismiss()
                            case .edit:
                                if let editingItem = editingItem {
                                    self.path = NavigationPath()
                                    self.path.append(NavigationRoute.challengeList)

                                }

                            }
                            print("✅ [AddChallengeView] 도전일기 저장완료")
                            
                        } else {
                            viewModel.isValidForm = true
                            print("❌ [AddChallengeView] 도전일기 저장 실패")
                            print("📝 제목: \(viewModel.title)")
                            print("📄 메모: \(viewModel.memo)")
                            print("📂 카테고리: \(viewModel.category)")
                            print("📅 시작일: \(viewModel.startDate)")
                            print("📅 종료일: \(viewModel.endDate)")
                            
                        }
                    }
                    
                }, label: "확인")
                .padding(.bottom, 34)
                

            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 20)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackBtn()
                            .padding(.leading, 5)
                            .contentShape(Rectangle())
                        
                    }.offset(x: -10)
                }
            }
            .sheet(isPresented: $isActiveCategory) {
                Spacer().frame(height: 56)
                
                CategoryListView(viewModel: viewModel, selectedIndex: $selectedCategory)
                    .presentationDetents([.large, .large])
                    .presentationDragIndicator(.visible)
 
            }
            .sheet(isPresented: $isActivePicker, onDismiss: {
                if isPickerStartData {
                    viewModel.startDate = date
                    didSelectStartDate = true
                } else {
                    viewModel.endDate = date
                    didSelectEndDate = true
                }
            }) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .presentationDetents([.medium, .medium])
                    .datePickerStyle(.graphical)
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.horizontal, 20)
                
            }
            
        }
        .onAppear {
            if mode == .add {
                viewModel.title = ""
                viewModel.memo = ""
                viewModel.startDate = Date()
                viewModel.endDate = Date()
                viewModel.category = nil
            }
            if mode == .edit, let item = editingItem {
                viewModel.loadChallenge(from: item, context: viewContext)
                }

        }
        
    }
    
    @ViewBuilder
    private func titleComponent() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            InquiryText(title: "목표", isRequired: true)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .foregroundColor(.gray01)
                    .cornerRadius(4)
                
                
                if viewModel.title.isEmpty {
                    Text("청소하기, 하루 5분 명상하기...")
                        .font(.H5MediumFont())
                        .foregroundColor(.gray02)
                        .padding(.leading, 17)
                }
                
                TextField("", text: $viewModel.title)
                    .offset(x: 17)
                    .onChange(of: viewModel.title) { newValue in
                        if newValue.count > 23 {
                            viewModel.title = String(newValue.prefix(23)) // 글자 수 제한
                        }
                    }
                    .font(.H5MediumFont())
                    .foregroundColor(.gray05)
            }
            
        }
    }
    
    @ViewBuilder
    private func categoryComponent() -> some View {
        let categoryValid = viewModel.category != nil
        
        HStack {
            InquiryText(title: "카테고리", isRequired: true)
            
            Spacer()
            
            Button(action: {
                isActiveCategory = true
            }, label: {
                Text(categoryValid ? viewModel.category?.groupTitle ?? "" : "카테고리를 선택해주세요")

                    .font(.H5MediumFont())
                    .foregroundColor(categoryValid ? .gray05 : .gray03)
                
                
                Image("icon_arrow_front_small")
                    .resizable()
                    .frame(width: 27, height: 27)
            })
            .buttonStyle(.plain)
            
        }
    }
    
    @ViewBuilder
    private func setDateComponent() -> some View {
        VStack(spacing: 25) {
            HStack {
                InquiryText(title: "시작일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                    isPickerStartData = true
                    date = viewModel.startDate
                }, label: {
                    Text(DateFormatter.koreanShort.string(from: viewModel.startDate))
                        .font(.H5MediumFont())
                        .foregroundColor(didSelectStartDate ? .gray05 : .gray03)
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
            
            HStack {
                InquiryText(title: "종료일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                    isPickerStartData = false
                    date = viewModel.endDate
                }, label: {
                    Text(DateFormatter.koreanShort.string(from: viewModel.endDate))
                        .font(.H5MediumFont())
                        .foregroundColor(didSelectEndDate ? .gray05 : .gray03)
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
        }
        
    }
    
    @ViewBuilder
    private func memoComponent() -> some View {
        VStack(alignment: .leading) {
            InquiryText(title: "다짐 및 도전 목표", isRequired: false)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.gray01)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                
                TextEditor(text: $viewModel.memo)
                    .font(.H4MediumFont())
                    .padding(.horizontal, 10)
                    .zIndex(0)
                    .colorMultiply(Color(.gray01))
                    .cornerRadius(6)
                
                
                if viewModel.memo.isEmpty {
                    Text("")
                        .font(.H5MediumFont())
                        .padding(.leading, 14)
                        .padding(.top, 16)
                        .foregroundColor(.gray02)
                        .cornerRadius(6)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .frame(maxWidth: .infinity, maxHeight: 150)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            if viewModel.isValidForm {
                Text("필수 입력 사항을 모두 채워 주세요.")
                    .font(.H6MediumFont())
                    .foregroundStyle(.red)
                    
            }
        }
    }
    
    
    
}

